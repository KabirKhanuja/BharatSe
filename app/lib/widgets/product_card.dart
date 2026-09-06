import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../session/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';
import '../util/format.dart';
import 'craft_image.dart';

/// Product tile used on Home and in every grid.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap, this.width});

  final Product product;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final origin = Catalog.stateById(product.stateId);
    final saved = app.isSaved(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: Radii.md,
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.05,
                  child: CraftImage(
                    seed: product.seed,
                    icon: product.icon,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: GestureDetector(
                    onTap: () => app.toggleSaved(product.id),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: saved ? AppColors.maroon : AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(origin.name(lang).toUpperCase(),
                      style: AppText.eyebrow, maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(product.name(lang),
                      style: AppText.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text(inr(product.price), style: AppText.price),
                  const SizedBox(height: Gap.sm),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 9,
                        backgroundColor: AppColors.creamAlt,
                        child: Text(
                          product.artisan(lang).characters.first,
                          style: AppText.body(9.5,
                              weight: FontWeight.w700, color: AppColors.terracotta),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${context.s.byArtisan} ${product.artisan(lang)}',
                          style: AppText.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
