import 'package:flutter/material.dart';
import '../../../data/catalog.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../util/format.dart';
import '../../../widgets/product_thumb.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final entries = app.cart.entries.toList();

    final items = [
      for (final e in entries)
        if (app.productById(e.key) case final product?) (product, e.value),
    ];
    final subtotal =
        items.fold<int>(0, (sum, it) => sum + it.$1.price * it.$2);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(s.cart, style: AppText.body(18, weight: FontWeight.w600)),
        centerTitle: false,
      ),
      body: items.isEmpty
          ? _Empty(onBrowse: () => Navigator.of(context).maybePop())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  Gap.page, Gap.md, Gap.page, Gap.section),
              children: [
                for (final (product, qty) in items) ...[
                  _CartTile(product: product, qty: qty),
                  const SizedBox(height: Gap.md),
                ],
                const SizedBox(height: Gap.sm),
                _Summary(subtotal: subtotal),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(
                  Gap.page, Gap.md, Gap.page, Gap.md),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s.total, style: AppText.caption),
                        Text(inr(subtotal),
                            style: AppText.body(19, weight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(width: Gap.lg),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          minimumSize: const Size(0, 52),
                        ),
                        child: Text(s.checkout,
                            style: AppText.body(15,
                                weight: FontWeight.w600,
                                color: AppColors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.product, required this.qty});
  final Product product;
  final int qty;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final origin = Catalog.stateById(product.stateId);

    return Dismissible(
      key: ValueKey('cart_${product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Gap.xl),
        decoration: BoxDecoration(
          color: AppColors.maroon.withValues(alpha: 0.12),
          borderRadius: Radii.md,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.maroon),
      ),
      onDismissed: (_) => app.removeFromCart(product.id),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.md,
          side: const BorderSide(color: AppColors.line),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Gap.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: ProductThumb(
                  source: product.imageUrl,
                  seed: product.seed,
                  icon: product.icon,
                  borderRadius: Radii.sm),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(origin.name(lang).toUpperCase(), style: AppText.eyebrow),
                    const SizedBox(height: 2),
                    Text(product.name(lang),
                        style: AppText.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Gap.sm),
                    Row(
                      children: [
                        Text(inr(product.price), style: AppText.price),
                        const Spacer(),
                        _QtyStepper(product: product, qty: qty),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.product, required this.qty});
  final Product product;
  final int qty;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    return Container(
      decoration: BoxDecoration(
        borderRadius: Radii.pill,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
            padding: EdgeInsets.zero,
            onPressed: () => app.setQty(product.id, qty - 1),
            icon: Icon(qty == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
                size: 16),
          ),
          SizedBox(
            width: 22,
            child: Text('$qty',
                textAlign: TextAlign.center,
                style: AppText.body(14, weight: FontWeight.w700)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
            padding: EdgeInsets.zero,
            onPressed: () => app.setQty(product.id, qty + 1),
            icon: const Icon(Icons.add_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.subtotal});
  final int subtotal;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.md,
        side: const BorderSide(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Gap.lg),
        child: Column(
          children: [
            _row(s.subtotal, inr(subtotal)),
            const SizedBox(height: Gap.sm),
            _row(s.delivery, s.freeDelivery, valueColor: AppColors.success),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Gap.md),
              child: Divider(height: 1),
            ),
            _row(s.total, inr(subtotal), bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: AppText.body(14,
                  weight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: bold ? AppColors.ink : AppColors.inkMuted)),
        ),
        Text(value,
            style: AppText.body(bold ? 16 : 14,
                weight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? AppColors.ink)),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({this.onBrowse});
  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                size: 46, color: AppColors.inkFaint),
            const SizedBox(height: Gap.lg),
            Text(s.cartEmpty,
                style: AppText.body(17, weight: FontWeight.w600)),
            const SizedBox(height: Gap.sm),
            Text(s.cartEmptyBody,
                textAlign: TextAlign.center, style: AppText.caption),
            const SizedBox(height: Gap.xl),
            FilledButton.tonal(
              onPressed: onBrowse,
              child: Text(s.startShopping,
                  style: AppText.body(14.5, weight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
