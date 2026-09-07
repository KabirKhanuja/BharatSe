import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../util/catalogue_images.dart';
import 'craft_image.dart';

/// Shows a saved product image, whether it lives on the phone or in storage.
///
/// One widget rather than a conditional at each call site, because getting it
/// wrong fails at runtime rather than at compile time: Image.file on a URL
/// throws, and it throws inside a build method.
class ProductThumb extends StatelessWidget {
  const ProductThumb({
    super.key,
    required this.source,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.seed = 0,
    this.icon = Icons.checkroom_rounded,
    this.fit = BoxFit.cover,
  });

  /// A local file path or a URL. Null or empty falls back to a placeholder.
  final String? source;
  final BorderRadius borderRadius;
  final int seed;
  final IconData icon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final value = source;

    if (value == null || value.isEmpty) {
      return CraftImage(seed: seed, icon: icon, borderRadius: borderRadius);
    }

    if (isRemoteImage(value)) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          value,
          fit: fit,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : ColoredBox(
                  color: AppColors.creamAlt,
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.8),
                    ),
                  ),
                ),
          // A dead URL must not take the tile down with it.
          errorBuilder: (context, _, __) =>
              CraftImage(seed: seed, icon: icon, borderRadius: borderRadius),
        ),
      );
    }

    // Local files do not exist on web, where the picker returns a blob path.
    if (kIsWeb) {
      return CraftImage(seed: seed, icon: icon, borderRadius: borderRadius);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        File(value),
        fit: fit,
        errorBuilder: (context, _, __) =>
            CraftImage(seed: seed, icon: icon, borderRadius: borderRadius),
      ),
    );
  }
}
