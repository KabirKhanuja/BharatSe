import 'package:flutter/material.dart';
import '../../../data/catalog.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../util/format.dart';
import '../../../widgets/craft_image.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final lang = app.lang;
    final origin = Catalog.stateById(product.stateId);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: AppColors.cream,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back_rounded,
                    size: 18, color: AppColors.ink),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => app.toggleSaved(product.id),
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    app.isSaved(product.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 17,
                    color: app.isSaved(product.id)
                        ? AppColors.maroon
                        : AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: Gap.sm),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CraftImage(
                seed: product.seed,
                icon: product.icon,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          SliverList.list(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(origin.name(lang).toUpperCase(), style: AppText.eyebrow),
                  const SizedBox(height: Gap.xs),
                  Text(product.name(lang),
                      style: lang.name == 'hi'
                          ? AppText.hi(22, weight: 700, color: AppColors.ink)
                          : AppText.en(24, weight: 600, color: AppColors.ink)),
                  const SizedBox(height: Gap.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(inr(product.price),
                          style: AppText.body(23,
                              weight: FontWeight.w700, color: AppColors.ink)),
                      const SizedBox(width: Gap.md),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(s.inStock,
                            style: AppText.body(12.5,
                                weight: FontWeight.w600,
                                color: AppColors.success)),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.xl),
                  _Passport(product: product, origin: origin),
                  const SizedBox(height: Gap.lg),
                  Text(s.aboutThisCraft, style: AppText.sectionTitleEn),
                  const SizedBox(height: Gap.sm),
                  Text(product.story(lang),
                      style: AppText.body(14, height: 1.6)),
                  const SizedBox(height: Gap.xl),
                  _Spec(label: s.material, value: product.material(lang)),
                  _Spec(label: s.technique, value: product.technique(lang)),
                  _Spec(label: s.madeIn, value: origin.name(lang)),
                  _Spec(label: s.hoursOfWork, value: '${product.hours}'),
                  const SizedBox(height: Gap.section),
                ],
              ),
            ),
          ]),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, Gap.md),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => app.addToCart(product.id),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    side: const BorderSide(color: AppColors.navy),
                    shape: const RoundedRectangleBorder(borderRadius: Radii.md),
                  ),
                  child: Text(s.addToCart,
                      style: AppText.body(14.5,
                          weight: FontWeight.w600, color: AppColors.navy)),
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    minimumSize: const Size(0, 50),
                    shape: const RoundedRectangleBorder(borderRadius: Radii.md),
                  ),
                  child: Text(s.buyNow,
                      style: AppText.body(14.5,
                          weight: FontWeight.w600, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The thing no competitor has. A signed, scannable provenance record tied to
/// the maker, shown to the buyer as a reason to trust the price.
class _Passport extends StatelessWidget {
  const _Passport({required this.product, required this.origin});
  final Product product;
  final CraftState origin;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;

    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.creamAlt,
              borderRadius: Radii.sm,
            ),
            child: const Icon(Icons.qr_code_2_rounded,
                size: 30, color: AppColors.navy),
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(s.craftPassport,
                        style: AppText.body(14,
                            weight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded,
                        size: 15, color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 3),
                Text(s.passportVerified, style: AppText.caption),
                const SizedBox(height: 5),
                Text(
                  '${s.artisanNote}: ${product.artisan(lang)} · ${origin.name(lang)}',
                  style: AppText.body(12, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 122,
            child: Text(label, style: AppText.body(13.5, color: AppColors.inkMuted)),
          ),
          Expanded(
            child: Text(value,
                style: AppText.body(13.5, weight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
