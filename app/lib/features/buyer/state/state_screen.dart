import 'package:flutter/material.dart';
import '../../../data/catalog.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/craft_image.dart';
import '../../../widgets/ornament.dart';
import '../../../widgets/product_card.dart';
import '../product/product_screen.dart';

/// What a buyer sees after tapping a state on the map.
///
/// Deliberately leads with the heritage text rather than the grid. The brief
/// is a marketplace for heritage crafts, so the story is the product.
class StateScreen extends StatelessWidget {
  const StateScreen({super.key, required this.state});
  final CraftState state;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final products =
        Catalog.products.where((p) => p.stateId == state.id).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: AppColors.cream,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 210,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back_rounded,
                    size: 18, color: AppColors.ink),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.md),
              title: Text(
                state.name(lang),
                style: AppText.body(19,
                    weight: FontWeight.w700, color: AppColors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CraftImage(
                    seed: state.seed,
                    icon: Icons.landscape_outlined,
                    borderRadius: BorderRadius.zero,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.ink.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.page, Gap.lg, Gap.page, 0),
            sliver: SliverList.list(children: [
              Row(
                children: [
                  Icon(Icons.brush_outlined, size: 16, color: AppColors.terracotta),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(state.crafts(lang),
                        style: AppText.body(13.5,
                            weight: FontWeight.w600,
                            color: AppColors.terracotta)),
                  ),
                  Text('${state.count} ${s.artisansHere}',
                      style: AppText.body(12, color: AppColors.inkFaint)),
                ],
              ),
              const SizedBox(height: Gap.lg),

              // The heritage note. This is the "history about the product"
              // half of the brief.
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: Radii.md,
                  side: BorderSide(color: AppColors.gold.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Gap.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(s.theCraft,
                              style: AppText.body(13.5,
                                  weight: FontWeight.w700,
                                  color: AppColors.ink)),
                          const SizedBox(width: Gap.sm),
                          const Expanded(child: GoldRule(width: double.infinity)),
                        ],
                      ),
                      const SizedBox(height: Gap.md),
                      Text(state.heritage(lang),
                          style: AppText.body(13.5, height: 1.65)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Gap.xxl),
              Text('${s.craftsFrom} ${state.name(lang)}',
                  style: context.lang.name == 'hi'
                      ? AppText.sectionTitleHi
                      : AppText.sectionTitleEn),
              const SizedBox(height: Gap.md),
            ]),
          ),
          if (products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Gap.section),
                child: Center(
                  child: Text(s.emptyWishlist, style: AppText.caption),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  Gap.page, 0, Gap.page, Gap.section),
              sliver: SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Gap.md,
                  crossAxisSpacing: Gap.md,
                  childAspectRatio: 0.66,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) => ProductCard(
                  product: products[i],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductScreen(product: products[i]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
