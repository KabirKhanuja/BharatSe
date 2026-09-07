import 'package:flutter/material.dart';
import '../../../data/catalog.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/craft_image.dart';
import '../../../widgets/ornament.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.controller, this.onExplore, this.onProduct, this.onState});

  /// Owned by the shell so tapping the active tab can scroll it to the top.
  final ScrollController? controller;

  final VoidCallback? onExplore;
  final void Function(Product)? onProduct;
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.only(bottom: Gap.section),
      children: [
        _Hero(onExplore: onExplore),
        const SizedBox(height: Gap.xxl),
        SectionHeader(
          title: context.s.shopByState,
          actionLabel: context.s.seeAll,
          onAction: onExplore,
          devanagari: context.lang.name == 'hi',
        ),
        _StateStrip(onState: onState),
        const SizedBox(height: Gap.xxl),
        SectionHeader(
          title: context.s.curatedForYou,
          actionLabel: context.s.seeAll,
          onAction: onExplore,
          devanagari: context.lang.name == 'hi',
        ),
        _ProductStrip(onProduct: onProduct),
        const SizedBox(height: Gap.xxl),
        const _TrustBanner(),
        const SizedBox(height: Gap.xxl),
        SectionHeader(
          title: context.s.newArrivals,
          actionLabel: context.s.seeAll,
          onAction: onExplore,
          devanagari: context.lang.name == 'hi',
        ),
        _ProductStrip(onProduct: onProduct, skip: 4),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({this.onExplore});
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final hi = context.lang.name == 'hi';

    TextStyle line(Color c) => hi
        ? AppText.hi(26, weight: 700, color: c, height: 1.42)
        : AppText.en(29, weight: 700, color: c, height: 1.16);

    // The height is set by the content, not hard-coded. A longer translation
    // or a larger system font size must push the hero taller rather than being
    // silently clipped.
    return Stack(
      children: [
        Positioned.fill(
          child: CraftImage(
            seed: 1,
            icon: Icons.back_hand_outlined,
            borderRadius: BorderRadius.zero,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 0.52, 1.0],
                colors: [
                  AppColors.cream,
                  AppColors.cream.withValues(alpha: 0.86),
                  AppColors.cream.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 292),
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(Gap.page, Gap.xl, Gap.page, Gap.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.heroLine1, style: line(AppColors.navy)),
                Text(s.heroLine2, style: line(AppColors.navy)),
                Text(s.heroLine3, style: line(AppColors.terracotta)),
                const SizedBox(height: Gap.md),
                const GoldRule(),
                const SizedBox(height: Gap.md),
                SizedBox(
                  width: 214,
                  child: Text(s.heroBody,
                      style: AppText.body(12.5, color: AppColors.inkMuted)),
                ),
                const SizedBox(height: Gap.lg),
                FilledButton(
                  onPressed: onExplore,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
                    shape: const RoundedRectangleBorder(borderRadius: Radii.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.heroCta,
                          style: AppText.body(14,
                              weight: FontWeight.w600, color: AppColors.white)),
                      const SizedBox(width: Gap.sm),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 16, color: AppColors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: Gap.page,
          bottom: Gap.md,
          child: Row(
            children: List.generate(
              5,
              (i) => Container(
                width: i == 0 ? 16 : 6,
                height: 6,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: i == 0
                      ? AppColors.navy
                      : AppColors.navy.withValues(alpha: 0.25),
                  borderRadius: Radii.pill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StateStrip extends StatelessWidget {
  const _StateStrip({this.onState});
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;
    final states = Catalog.states.take(6).toList();

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Gap.page),
        itemCount: states.length,
        separatorBuilder: (_, __) => const SizedBox(width: Gap.lg),
        itemBuilder: (context, i) {
          final st = states[i];
          return GestureDetector(
            onTap: () => onState?.call(st),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 76,
                        height: 76,
                        child: CraftImage(
                          seed: st.seed,
                          icon: Icons.landscape_outlined,
                          borderRadius: Radii.pill,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 1),
                          ),
                          child: const Icon(Icons.spa_outlined,
                              size: 11, color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.sm),
                  Text(
                    st.name(lang),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(12.5, weight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Why the price is what it is, stated before the buyer asks.
class _TrustBanner extends StatelessWidget {
  const _TrustBanner();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.page),
      child: Container(
        padding: const EdgeInsets.all(Gap.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: Radii.md,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.creamAlt,
                borderRadius: Radii.sm,
              ),
              child: const Icon(Icons.qr_code_2_rounded,
                  size: 24, color: AppColors.navy),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.trustTitle,
                      style: AppText.body(14,
                          weight: FontWeight.w600, color: AppColors.ink,
                          height: 1.35)),
                  const SizedBox(height: 4),
                  Text(s.trustBody, style: AppText.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductStrip extends StatelessWidget {
  const _ProductStrip({this.onProduct, this.skip = 0});
  final void Function(Product)? onProduct;
  final int skip;

  @override
  Widget build(BuildContext context) {
    final products = context.app.catalogProducts.skip(skip).take(6).toList();

    // Nothing to show yet is a real state, not an error: the catalogue is
    // still loading, or this buyer has no signal.
    if (products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 296,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Gap.page),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: Gap.md),
        itemBuilder: (context, i) => ProductCard(
          product: products[i],
          width: 168,
          onTap: () => onProduct?.call(products[i]),
        ),
      ),
    );
  }
}
