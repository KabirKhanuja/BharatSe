import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/product_store.dart';
import '../../data/remote/api_client.dart';
import '../../data/remote/api_models.dart';
import '../../l10n/strings.dart';
import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import '../../util/format.dart';
import '../../util/wage_floor.dart';
import '../../widgets/craft_image.dart';
import '../../widgets/offline.dart';
import '../../widgets/panel.dart';
import '../../widgets/wordmark.dart';

/// The listing flow. Photo, then hold the mic and talk, and the rest fills
/// itself in.
///
/// Everything here works with no signal. Capture is local, the listing call is
/// attempted and skipped if unreachable, and publishing goes into the outbox
/// rather than onto the network.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  final _clientId = const Uuid().v4();

  final List<String> _photos = [];
  bool _recording = false;
  bool _working = false;
  String? _error;

  GeneratedListing? _listing;
  PriceBand? _band;

  double _hours = 7;
  final int _materialCost = 380;
  int? _price;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// The server's floor when we have it, the locally computed one when we do
  /// not. Same arithmetic either way.
  int get _floor =>
      _band?.floor ??
      computeFloor(materialCost: _materialCost, hours: _hours).floor;

  // ------------------------------------------------------------------ photos
  Future<void> _addPhoto() async {
    final path = await context.app.capture.takePhoto();
    if (path != null && mounted) setState(() => _photos.add(path));
  }

  // --------------------------------------------------------------- recording
  Future<void> _startRecording() async {
    final capture = context.app.capture;
    if (!await capture.startRecording()) {
      if (mounted) setState(() => _error = context.s.micNeeded);
      return;
    }
    _pulse.repeat(reverse: true);
    if (mounted) setState(() => _recording = true);
  }

  Future<void> _stopRecording() async {
    _pulse.stop();
    _pulse.value = 0;

    final app = context.app;
    final path = await app.capture.stopRecording();
    if (!mounted) return;
    setState(() => _recording = false);

    if (path == null) {
      setState(() => _error = context.s.noteTooShort);
      return;
    }

    setState(() {
      _working = true;
      _error = null;
    });

    try {
      final result = await app.api.generateListing(
        audioPath: path,
        language: app.lang.name == 'hi' ? 'hi' : null,
      );
      if (!mounted) return;

      setState(() {
        _listing = result.listing;
        if (result.listing.estimatedHours != null) {
          _hours = result.listing.estimatedHours!;
        }
      });
      await _refreshPrice();
    } on ApiException catch (error) {
      if (!mounted) return;
      // Offline is not a failure here. The note stays on the phone and the
      // listing is written the next time there is a signal.
      setState(() => _error = error.isOffline
          ? context.s.offlineNotice
          : '${context.s.couldNotGenerate}. ${error.message}');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  // ----------------------------------------------------------------- pricing
  Future<void> _refreshPrice() async {
    final app = context.app;
    try {
      final band = await app.api.suggestPrice(
        hoursOfWork: _hours,
        materialCost: _materialCost,
        category: _listing?.category ?? 'other',
        material: _listing?.materials.firstOrNull ?? 'unknown',
        technique: _listing?.technique ?? 'unknown',
        title: _listing?.titleEn ?? '',
        description: _listing?.descriptionEn ?? '',
      );
      if (!mounted) return;
      setState(() {
        _band = band;
        _price = _price == null ? band.p50 : enforceFloor(_price!, band.floor);
      });
    } on ApiException {
      // Keep the locally computed floor. An artisan on a bad connection still
      // gets a number she can act on.
      if (mounted) setState(() => _price = _price ?? (_floor * 1.55).round());
    }
  }

  void _setHours(double next) {
    setState(() {
      _hours = next.clamp(1, 60);
      if (_price != null) _price = enforceFloor(_price!, _floor);
    });
    _refreshPrice();
  }

  // ----------------------------------------------------------------- publish
  Future<void> _publish() async {
    final app = context.app;

    await app.sync.enqueue(
      clientId: _clientId,
      entity: 'product',
      op: 'upsert',
      payload: {
        'title_en': _listing?.titleEn,
        'title_hi': _listing?.titleHi,
        'description_en': _listing?.descriptionEn,
        'description_hi': _listing?.descriptionHi,
        'category': _listing?.category,
        'material': _listing?.materials.firstOrNull,
        'technique': _listing?.technique,
        'hours_of_work': _hours,
        'material_cost': _materialCost,
        'price': _price ?? _floor,
      },
    );

    // Write it locally too. The catalogue reads from the phone, so without
    // this the artisan publishes something and then sees an empty list.
    await app.products.save(LocalProduct(
      clientId: _clientId,
      createdAt: DateTime.now(),
      synced: false,
      titleEn: _listing?.titleEn,
      titleHi: _listing?.titleHi,
      descriptionEn: _listing?.descriptionEn,
      descriptionHi: _listing?.descriptionHi,
      category: _listing?.category,
      material: _listing?.materials.firstOrNull,
      technique: _listing?.technique,
      hoursOfWork: _hours,
      materialCost: _materialCost,
      priceFloor: _floor,
      price: _price ?? _floor,
      imagePaths: _photos,
    ));

    if (!mounted) return;
    final offline = app.link == LinkState.offline;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(offline ? context.s.savedOnPhone : context.s.published),
      ),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            ConnectionStrip(state: app.link, queued: app.queued),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, Gap.xxl),
                children: [
                  _photoSection(),
                  const SizedBox(height: Gap.lg),
                  _micWell(),
                  if (_error != null) ...[
                    const SizedBox(height: Gap.md),
                    _errorNote(),
                  ],
                  if (_listing != null) ...[
                    const SizedBox(height: Gap.xl),
                    _suggestionsHeader(),
                    const SizedBox(height: Gap.md),
                    if (_photos.isNotEmpty) ...[
                      _enhancedImages(),
                      const SizedBox(height: Gap.md),
                    ],
                    _story(),
                    const SizedBox(height: Gap.md),
                    _pricing(),
                    const SizedBox(height: Gap.md),
                    _details(),
                  ],
                ],
              ),
            ),
            _publishBar(s),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ header
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.sm, Gap.sm, Gap.sm, Gap.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.ink,
          ),
          const Expanded(
            child: Center(child: Wordmark(size: 22, showTagline: false)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline_rounded),
            color: AppColors.ink,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------ photos
  Widget _photoSection() {
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.photo_library_outlined,
                size: 18, color: AppColors.terracotta),
            const SizedBox(width: Gap.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.addPhotos, style: AppText.label),
                  const SizedBox(height: 2),
                  Text(s.addPhotosSub, style: AppText.caption),
                ],
              ),
            ),
            Text('${_photos.length}/10',
                style: AppText.body(13,
                    weight: FontWeight.w600, color: AppColors.maroon)),
          ],
        ),
        const SizedBox(height: Gap.md),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _photos.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: Gap.md),
            itemBuilder: (context, i) =>
                i == 0 ? _addTile() : _thumb(i - 1),
          ),
        ),
      ],
    );
  }

  Widget _addTile() {
    return GestureDetector(
      key: const Key('add-photo'),
      onTap: _addPhoto,
      child: Container(
        width: 104,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: Radii.md,
          border: Border.all(
            color: AppColors.terracotta.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined,
                size: 24, color: AppColors.terracotta),
            const SizedBox(height: 6),
            Text(context.s.addPhoto,
                textAlign: TextAlign.center,
                style: AppText.body(11.5,
                    weight: FontWeight.w500, color: AppColors.terracotta)),
          ],
        ),
      ),
    );
  }

  Widget _thumb(int i) {
    return SizedBox(
      width: 104,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: Radii.md,
              child: kIsWeb
                  ? const CraftImage(seed: 1, icon: Icons.checkroom_rounded)
                  : Image.file(File(_photos[i]), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => setState(() => _photos.removeAt(i)),
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                    color: AppColors.ink, shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded,
                    size: 14, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------- mic
  Widget _micWell() {
    final s = context.s;

    final label = _working
        ? s.preparing
        : _recording
            ? s.listening
            : s.holdToDescribe;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Gap.xl, horizontal: Gap.lg),
      decoration: BoxDecoration(
        color: AppColors.creamAlt,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          GestureDetector(
            key: const Key('mic'),
            onLongPressStart: (_) => _working ? null : _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = _recording ? _pulse.value : 0.0;
                return Container(
                  width: 58 + t * 8,
                  height: 58 + t * 8,
                  decoration: BoxDecoration(
                    color: _working ? AppColors.inkFaint : AppColors.maroon,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.maroon.withValues(alpha: 0.18 + t * 0.22),
                        blurRadius: 12 + t * 18,
                        spreadRadius: t * 6,
                      ),
                    ],
                  ),
                  child: _working
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.white),
                        )
                      : const Icon(Icons.mic_rounded,
                          color: AppColors.white, size: 26),
                );
              },
            ),
          ),
          const SizedBox(height: Gap.md),
          Text(label,
              textAlign: TextAlign.center,
              style: AppText.body(14.5,
                  weight: FontWeight.w600,
                  color: _recording ? AppColors.maroon : AppColors.ink)),
          const SizedBox(height: 3),
          Text(_recording ? s.releaseToFinish : s.inYourLanguage,
              textAlign: TextAlign.center, style: AppText.caption),
        ],
      ),
    );
  }

  Widget _errorNote() {
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFEF),
        borderRadius: Radii.sm,
        border: Border.all(color: AppColors.maroon.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.maroon),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(_error!,
                style: AppText.body(12.5, color: AppColors.maroon, height: 1.35)),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- suggestions
  Widget _suggestionsHeader() {
    return Row(
      children: [
        const Icon(Icons.auto_awesome, size: 17, color: AppColors.gold),
        const SizedBox(width: Gap.sm),
        Text(context.s.aiSuggestions, style: AppText.label),
      ],
    );
  }

  Widget _enhancedImages() {
    final s = context.s;
    return Panel(
      icon: Icons.auto_fix_high_outlined,
      title: s.enhancedImages,
      child: Row(
        children: [
          Expanded(child: _framed(s.beforeLabel, dim: true)),
          const SizedBox(width: Gap.md),
          Expanded(child: _framed(s.afterLabel, dim: false, accent: true)),
        ],
      ),
    );
  }

  Widget _framed(String label, {required bool dim, bool accent = false}) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: Radii.md,
              child: kIsWeb
                  ? CraftImage(seed: dim ? 0 : 1, dim: dim)
                  : ColorFiltered(
                      colorFilter: dim
                          ? const ColorFilter.mode(
                              Color(0x22FFFFFF), BlendMode.lighten)
                          : const ColorFilter.mode(
                              Colors.transparent, BlendMode.dst),
                      child: Image.file(File(_photos.first), fit: BoxFit.cover),
                    ),
            ),
          ),
          Positioned(
            top: 7,
            left: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent ? AppColors.maroon : AppColors.ink,
                borderRadius: Radii.sm,
              ),
              child: Text(label,
                  style: AppText.body(10.5,
                      weight: FontWeight.w600, color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------- story
  Widget _story() {
    final hi = context.lang.name == 'hi';
    final text =
        hi ? _listing!.descriptionHi : _listing!.descriptionEn;

    return Panel(
      icon: Icons.article_outlined,
      title: context.s.productStory,
      onEdit: () {},
      onSpeak: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Gap.md),
        decoration: BoxDecoration(color: AppColors.cream, borderRadius: Radii.sm),
        child: Text(text,
            style: AppText.body(13.5, color: AppColors.ink, height: 1.6)),
      ),
    );
  }

  // ----------------------------------------------------------------- pricing
  Widget _pricing() {
    final s = context.s;
    final band = _band;
    final price = _price ?? _floor;

    return Panel(
      icon: Icons.trending_up_rounded,
      title: s.suggestedPrice,
      onEdit: () {},
      onSpeak: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(band?.note.isNotEmpty == true ? band!.note : s.priceIsFair,
                        style: AppText.body(12.5,
                            weight: FontWeight.w600, color: AppColors.maroon)),
                    const SizedBox(height: 3),
                    if (band != null)
                      Text('${inr(band.p10)} ${s.priceRange} ${inr(band.p90)}',
                          style: AppText.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Gap.lg, vertical: Gap.sm),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: Radii.sm,
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(inr(price),
                    style: AppText.body(17,
                        weight: FontWeight.w700, color: AppColors.ink)),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          _floorBar(),
        ],
      ),
    );
  }

  Widget _floorBar() {
    final s = context.s;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0E6),
        borderRadius: Radii.sm,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 16, color: AppColors.gold),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppText.body(12.5, color: AppColors.inkMuted, height: 1.4),
                children: [
                  TextSpan(text: '${s.neverBelowWage} '),
                  TextSpan(
                    text: '${s.lowestPrice} ${inr(_floor)}',
                    style: AppText.body(12.5,
                        weight: FontWeight.w700, color: AppColors.ink),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- details
  Widget _details() {
    final s = context.s;
    final lang = context.lang;
    final listing = _listing!;

    return Panel(
      icon: Icons.sell_outlined,
      title: s.productDetails,
      onEdit: () {},
      onSpeak: () {},
      child: Column(
        children: [
          _row(s.material, listing.materials.join(', ')),
          _row(s.technique, listing.technique),
          _row(s.categoryLabel, listing.category),
          if (listing.transcript.isNotEmpty)
            _row(lang.name == 'hi' ? 'आपने कहा' : 'You said', listing.transcript),
          const Divider(height: Gap.xl),
          _hoursRow(),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(k, style: AppText.body(13, color: AppColors.inkMuted)),
          ),
          Expanded(
            child: Text(v,
                style: AppText.body(13,
                    weight: FontWeight.w500, color: AppColors.ink)),
          ),
        ],
      ),
    );
  }

  /// Hours is the artisan's own number and it drives the floor. Changing it
  /// re-prices the item, and if the new floor overtakes the asking price the
  /// price is lifted to meet it.
  Widget _hoursRow() {
    final s = context.s;
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Text(s.hoursTaken,
              style:
                  AppText.body(13, weight: FontWeight.w600, color: AppColors.ink)),
        ),
        Expanded(
          child: Row(
            children: [
              _step(Icons.remove_rounded, () => _setHours(_hours - 1),
                  key: const Key('hours-minus')),
              SizedBox(
                width: 78,
                child: Center(
                  child: Text(
                      '${_hours.toStringAsFixed(0)} ${s.hoursUnit}',
                      style: AppText.body(14,
                          weight: FontWeight.w700, color: AppColors.ink)),
                ),
              ),
              _step(Icons.add_rounded, () => _setHours(_hours + 1),
                  key: const Key('hours-plus')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step(IconData icon, VoidCallback onTap, {Key? key}) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: Radii.sm,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: Radii.sm,
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: 17, color: AppColors.ink),
      ),
    );
  }

  // ----------------------------------------------------------------- publish
  Widget _publishBar(AppStrings s) {
    final offline = context.app.link == LinkState.offline;
    final ready = _listing != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, Gap.md),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.maroon,
            disabledBackgroundColor: AppColors.line,
            shape: const RoundedRectangleBorder(borderRadius: Radii.md),
            padding: const EdgeInsets.symmetric(horizontal: Gap.md),
          ),
          onPressed: ready ? _publish : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  offline ? s.saveOnPhoneCta : s.publishToMarket,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(16,
                      weight: FontWeight.w600, color: AppColors.white),
                ),
              ),
              const SizedBox(width: Gap.sm),
              Icon(offline ? Icons.save_alt_rounded : Icons.storefront_outlined,
                  size: 19, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
