import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../util/format.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import '../../widgets/craft_image.dart';
import '../../widgets/offline.dart';
import '../../widgets/panel.dart';
import '../../widgets/wordmark.dart';

/// Step 2 of the listing flow. The screen the whole product is judged on.
///
/// Flow: add photos, hold the mic and talk, and everything below fills itself
/// in. Nothing here requires typing and nothing here requires reading, because
/// every block can be played aloud.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    super.key,
    this.link = LinkState.online,
    this.queued = 0,
  });

  final LinkState link;

  /// How many items are sitting in the outbox, unsent.
  final int queued;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  bool _recording = false;
  bool _hasResult = true; // pre-filled so the screen reads complete on open
  int _photos = 2;

  // Pricing inputs. Hours is the artisan's own number and it drives the floor,
  // which is the whole ethical position made visible.
  double _hours = 7;
  int _price = 1250;

  static const _materialCost = 380; // raw silk, from the materials index
  static const _wagePerHour = 60; // fair wage floor, not market rate

  int get _floor => _materialCost + (_hours * _wagePerHour).round();
  bool get _belowFloor => _price < _floor;

  // Runs only while the mic is held. A controller left repeating forever burns
  // CPU on exactly the low-end phones this app is built for.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            ConnectionStrip(state: widget.link, queued: widget.queued),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, Gap.xxl),
                children: [
                  _photoSection(),
                  const SizedBox(height: Gap.lg),
                  _micWell(),
                  if (_hasResult) ...[
                    const SizedBox(height: Gap.xl),
                    _suggestionsHeader(),
                    const SizedBox(height: Gap.md),
                    _enhancedImages(),
                    const SizedBox(height: Gap.md),
                    _story(),
                    const SizedBox(height: Gap.md),
                    _pricing(),
                    const SizedBox(height: Gap.md),
                    _details(),
                  ],
                ],
              ),
            ),
            _publishBar(),
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
            onPressed: () {},
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
                  Text('फ़ोटो या वीडियो जोड़ें', style: AppText.label),
                  const SizedBox(height: 2),
                  Text('अपने सामान की साफ़ तस्वीरें लगाइए',
                      style: AppText.caption),
                ],
              ),
            ),
            Text('2/10',
                style: AppText.body(13,
                    weight: FontWeight.w600, color: AppColors.maroon)),
          ],
        ),
        const SizedBox(height: Gap.md),
        SizedBox(
          height: 104,
          child: Row(
            children: [
              _addTile(),
              const SizedBox(width: Gap.md),
              for (var i = 0; i < _photos; i++) ...[
                _thumb(i),
                if (i != _photos - 1) const SizedBox(width: Gap.md),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _addTile() {
    return GestureDetector(
      onTap: () => setState(() => _photos = (_photos + 1).clamp(0, 4)),
      child: Container(
        width: 104,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: Radii.md,
          border: Border.all(
            color: AppColors.terracotta.withValues(alpha: 0.35),
            width: 1.2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, size: 26, color: AppColors.terracotta),
            const SizedBox(height: 6),
            Text('फ़ोटो जोड़ें',
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
            child: CraftImage(seed: i, icon: Icons.checkroom_rounded),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => setState(() => _photos = (_photos - 1).clamp(0, 4)),
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
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
            onLongPressStart: (_) {
              setState(() => _recording = true);
              _pulse.repeat(reverse: true);
            },
            onLongPressEnd: (_) {
              _pulse.stop();
              _pulse.value = 0;
              setState(() {
                _recording = false;
                _hasResult = true;
              });
            },
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final t = _recording ? _pulse.value : 0.0;
                return Container(
                  width: 58 + t * 8,
                  height: 58 + t * 8,
                  decoration: BoxDecoration(
                    color: AppColors.maroon,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.maroon.withValues(alpha: 0.18 + t * 0.22),
                        blurRadius: 12 + t * 18,
                        spreadRadius: t * 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic_rounded,
                      color: AppColors.white, size: 26),
                );
              },
            ),
          ),
          const SizedBox(height: Gap.md),
          Text(
            _recording ? 'सुन रहे हैं… बोलते रहिए' : 'दबाकर अपने सामान के बारे में बताइए',
            style: AppText.body(14.5,
                weight: FontWeight.w600,
                color: _recording ? AppColors.maroon : AppColors.ink),
          ),
          const SizedBox(height: 3),
          Text('अपनी भाषा में (हिन्दी, बंगाली, तमिल…)', style: AppText.caption),
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
        Text('आपके लिए तैयार किया गया', style: AppText.label),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.creamAlt,
            borderRadius: Radii.pill,
            border: Border.all(color: AppColors.line),
          ),
          child: Text('AI',
              style: AppText.body(10.5,
                  weight: FontWeight.w700, color: AppColors.inkMuted)),
        ),
      ],
    );
  }

  Widget _enhancedImages() {
    return Panel(
      icon: Icons.auto_fix_high_outlined,
      title: 'बेहतर की गई तस्वीरें',
      child: Row(
        children: [
          Expanded(child: _framed('पहले', dim: true, seed: 0)),
          const SizedBox(width: Gap.md),
          Expanded(child: _framed('बाद में', dim: false, seed: 1, accent: true)),
        ],
      ),
    );
  }

  Widget _framed(String label,
      {required bool dim, required int seed, bool accent = false}) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Stack(
        children: [
          Positioned.fill(
            child: CraftImage(
                seed: seed, dim: dim, icon: Icons.checkroom_rounded),
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
    return Panel(
      icon: Icons.article_outlined,
      title: 'सामान की कहानी',
      onEdit: () {},
      onSpeak: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Gap.md),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: Radii.sm,
        ),
        child: Text(
          'यह हाथ से बुना हुआ रेशमी दुपट्टा है जिस पर पारंपरिक फूलों की '
          'कढ़ाई है। यह हल्का और हर मौसम के लिए उपयुक्त है, और हमारी बुनाई '
          'की विरासत को आगे ले जाता है।',
          style: AppText.body(13.5, color: AppColors.ink, height: 1.6),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- pricing
  Widget _pricing() {
    return Panel(
      icon: Icons.trending_up_rounded,
      title: 'सुझाया गया दाम',
      onEdit: () {},
      onSpeak: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('आज के बाज़ार के हिसाब से सही',
                        style: AppText.body(12.5,
                            weight: FontWeight.w600,
                            color: AppColors.maroon)),
                    const SizedBox(height: 3),
                    Text('₹1,050 से ₹1,480 के बीच',
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
                  border: Border.all(
                      color: _belowFloor ? AppColors.maroon : AppColors.line,
                      width: _belowFloor ? 1.4 : 1),
                ),
                child: Text(inr(_price),
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

  /// The fair wage floor, stated as a number the artisan can see move.
  Widget _floorBar() {
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
                  const TextSpan(text: 'आपकी मेहनत से कम दाम कभी नहीं। '),
                  TextSpan(
                    text: 'सबसे कम ${inr(_floor)}',
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
    return Panel(
      icon: Icons.sell_outlined,
      title: 'सामान का ब्यौरा',
      onEdit: () {},
      onSpeak: () {},
      child: Column(
        children: [
          _row('श्रेणी', 'दुपट्टे और स्टोल'),
          _row('कच्चा माल', 'शुद्ध रेशम'),
          _row('तकनीक', 'हाथ से बुना'),
          _row('डिज़ाइन', 'फूलदार'),
          _row('रंग', 'बेज और भूरा'),
          _row('नाप', '१८० सेमी x ७० सेमी'),
          const Divider(height: Gap.xl),
          _hoursRow(),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
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

  /// Hours is the one detail the artisan should always correct herself, because
  /// it moves the floor. Tapping the steppers re-prices the item live.
  Widget _hoursRow() {
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Text('कितने घंटे लगे',
              style: AppText.body(13, weight: FontWeight.w600, color: AppColors.ink)),
        ),
        Expanded(
          child: Row(
            children: [
              _step(Icons.remove_rounded, () => _setHours(_hours - 1),
                  key: const Key('hours-minus')),
              SizedBox(
                width: 62,
                child: Center(
                  child: Text('${_hours.toStringAsFixed(0)} घंटे',
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

  /// Changing hours re-prices the item. If the new floor overtakes the asking
  /// price, the price is lifted to meet it. The system cannot be made to
  /// suggest less than the maker's own labour is worth.
  void _setHours(double next) {
    setState(() {
      _hours = next.clamp(1, 60);
      if (_price < _floor) _price = _floor;
    });
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
  Widget _publishBar() {
    final offline = widget.link == LinkState.offline;
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
            shape: const RoundedRectangleBorder(borderRadius: Radii.md),
            padding: const EdgeInsets.symmetric(horizontal: Gap.md),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  offline ? 'फ़ोन में सुरक्षित करें' : 'बाज़ार में भेजें',
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
