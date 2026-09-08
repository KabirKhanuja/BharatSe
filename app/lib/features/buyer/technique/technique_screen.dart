import 'package:flutter/material.dart';

import '../../../l10n/lang.dart';
import '../../../data/techniques.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/ornament.dart';
import '../../../widgets/product_card.dart';
import '../product/product_screen.dart';

/// One craft technique: what it is, where it comes from, and the pieces made
/// that way.
///
/// The history leads and the grid follows, deliberately. A buyer who has just
/// read what Dhokra actually involves reads the price underneath it
/// differently, and that is the whole argument for putting heritage in a
/// marketplace rather than in an about page nobody opens.
class TechniqueScreen extends StatelessWidget {
  const TechniqueScreen({super.key, required this.technique});
  final Technique technique;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;

    final products = [
      for (final product in context.app.catalogProducts)
        if (product.technique(Lang.en).trim().toLowerCase() == technique.key)
          product,
    ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(technique.title,
            style: AppText.body(17, weight: FontWeight.w600)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, 0),
            sliver: SliverList.list(children: [
              Row(
                children: [
                  const Icon(Icons.place_outlined,
                      size: 15, color: AppColors.terracotta),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${s.practisedIn} ${technique.region}',
                      style: AppText.body(13,
                          weight: FontWeight.w600, color: AppColors.terracotta),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.lg),

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
                          Text(s.theTradition,
                              style: AppText.body(13.5,
                                  weight: FontWeight.w700, color: AppColors.ink)),
                          const SizedBox(width: Gap.sm),
                          const Expanded(child: GoldRule(width: double.infinity)),
                        ],
                      ),
                      const SizedBox(height: Gap.md),
                      Text(technique.history(lang),
                          style: AppText.body(13.5, height: 1.75)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Gap.md),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Gap.lg),
                decoration: BoxDecoration(
                  color: AppColors.creamAlt,
                  borderRadius: Radii.md,
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 17, color: AppColors.gold),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.whyItCosts,
                              style: AppText.body(12.5,
                                  weight: FontWeight.w700,
                                  color: AppColors.inkMuted)),
                          const SizedBox(height: 4),
                          Text(technique.whyItCosts,
                              style: AppText.body(13, height: 1.55)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Gap.xxl),

              Row(
                children: [
                  Expanded(
                    child: Text(s.piecesUsing,
                        style: context.lang.name == 'hi'
                            ? AppText.sectionTitleHi
                            : AppText.sectionTitleEn),
                  ),
                  Text('${products.length}',
                      style: AppText.body(14, color: AppColors.inkMuted)),
                ],
              ),
              const SizedBox(height: Gap.md),
            ]),
          ),

          if (products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    Gap.page, 0, Gap.page, Gap.section),
                child: Text(s.noPiecesYet, style: AppText.caption),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  Gap.page, 0, Gap.page, Gap.section),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Gap.md,
                  crossAxisSpacing: Gap.md,
                  childAspectRatio: 0.60,
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
