import 'package:flutter/material.dart';

import '../../../data/local/product_store.dart';
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
    try {
      final items = await context.app.products.all();
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
              source: product.imagePaths.firstOrNull,
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
