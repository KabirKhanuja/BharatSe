import 'package:flutter/material.dart';

import '../../../data/local/product_store.dart';
import '../../../data/remote/api_client.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../util/format.dart';
import '../../../widgets/product_thumb.dart';

/// The artisan's catalogue.
///
/// Reads from the phone, not the network, so it opens with no signal. Anything
/// still queued is labelled as saved and waiting rather than as failed, which
/// is the difference between the offline feature existing and not.
class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key, required this.onAdd});
  final VoidCallback onAdd;

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  List<LocalProduct> _products = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Anything thrown here used to leave _loading true forever, which is what
    // the endless spinner was. An empty catalogue and a failed read are
    // different things and the screen now says which.
    final app = context.app;
    try {
      final items = await app.products.all(ownerId: app.userId);
      if (!mounted) return;
      setState(() {
        _products = items;
        _error = null;
      });
    } catch (error) {
      debugPrint('[seller] could not read local products: $error');
      if (!mounted) return;
      setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    await _mergeServerCatalogue(app);
  }

  /// Fold in what the server holds for this artisan.
  ///
  /// The phone is the source of truth only for work it has not sent yet. Once
  /// a listing is on the server it belongs to the account, not to the handset,
  /// so a reinstall or a cleared cache should not lose it. Local rows win on
  /// conflict because they may carry edits that have not synced, and their
  /// images are on disk rather than behind a network call.
  Future<void> _mergeServerCatalogue(AppState app) async {
    final owner = app.userId;
    if (owner == null) return;

    try {
      final remote = await app.api.listProducts(limit: 100);
      if (!mounted) return;

      // Claim rows this phone already holds that the server agrees are ours,
      // including any written before listings had an owner. Doing this before
      // the merge keeps their on disk photographs, which a blind overwrite
      // from the server would drop.
      await app.products.adopt([for (final r in remote) r.clientId], owner);
      final mine = await app.products.all(ownerId: owner);
      if (!mounted) return;
      setState(() => _products = mine);

      final known = {for (final p in _products) p.clientId};
      final restored = [
        for (final r in remote)
          if (!known.contains(r.clientId))
            LocalProduct(
              clientId: r.clientId,
              createdAt: r.createdAt,
              synced: true,
              ownerId: owner,
              serverId: r.id,
              titleEn: r.titleEn,
              titleHi: r.titleHi,
              price: r.price,
              priceFloor: r.priceFloor,
              remoteImageUrls: r.imageUrls,
            ),
      ];
      if (restored.isEmpty) return;

      // Keep them, so the next cold open is instant and works offline.
      for (final product in restored) {
        await app.products.save(product);
      }

      if (!mounted) return;
      setState(() {
        _products = [..._products, ...restored]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } on ApiException catch (error) {
      // The phone's own copy is already on screen. A catalogue that loads
      // offline is the whole point, so a failed refresh is not an error state.
      debugPrint('[seller] could not refresh from server: ${error.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(Gap.section),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, Gap.section),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.myProducts,
                  style: context.lang.name == 'hi'
                      ? AppText.sectionTitleHi
                      : AppText.sectionTitleEn,
                ),
              ),
              Text('${_products.length}',
                  style: AppText.body(14, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: Gap.md),

          if (_error != null)
            _failed(s)
          else if (_products.isEmpty)
            _empty(s)
          else
            for (final product in _products) ...[
              _tile(product),
              const SizedBox(height: Gap.md),
            ],
        ],
      ),
    );
  }

  Widget _empty(dynamic s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.section),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 44, color: AppColors.inkFaint),
          const SizedBox(height: Gap.lg),
          Text(s.noProductsYet,
              style: AppText.body(16, weight: FontWeight.w600)),
          const SizedBox(height: Gap.sm),
          Text(s.noProductsBody,
              textAlign: TextAlign.center, style: AppText.caption),
          const SizedBox(height: Gap.xl),
          FilledButton.icon(
            onPressed: widget.onAdd,
            style: FilledButton.styleFrom(backgroundColor: AppColors.maroon),
            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
            label: Text(s.addProduct,
                style: AppText.body(14.5,
                    weight: FontWeight.w600, color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Widget _failed(dynamic s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.section),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.inkFaint),
          const SizedBox(height: Gap.lg),
          Text(s.couldNotGenerate, style: AppText.body(15, weight: FontWeight.w600)),
          const SizedBox(height: Gap.lg),
          OutlinedButton(onPressed: _load, child: Text(s.tryAgain)),
        ],
      ),
    );
  }

  Widget _tile(LocalProduct product) {
    final s = context.s;
    final lang = context.lang.name;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: ProductThumb(
              // Local file first. It is already on disk, so it draws without a
              // round trip and without a signal.
              source: product.imagePaths.firstOrNull ??
                  product.remoteImageUrls.firstOrNull,
              borderRadius: Radii.sm,
              seed: 2,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title(lang).isEmpty ? s.draft : product.title(lang),
                  style: AppText.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (product.price != null)
                  Text(inr(product.price!), style: AppText.price),
                const SizedBox(height: Gap.sm),
                _statusChip(product, s),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(LocalProduct product, dynamic s) {
    final synced = product.synced;
    final label = synced ? s.published : s.waitingToSync;
    final colour = synced ? AppColors.success : AppColors.offline;
    final icon = synced ? Icons.check_circle_outline_rounded : Icons.schedule_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.08),
        borderRadius: Radii.pill,
        border: Border.all(color: colour.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colour),
          const SizedBox(width: 5),
          Text(label,
              style: AppText.body(11, weight: FontWeight.w600, color: colour)),
        ],
      ),
    );
  }
}
