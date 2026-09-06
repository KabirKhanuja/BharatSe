import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';

/// Stand-in for a real photograph.
///
/// Draws a warm gradient in the brand palette with a faint craft glyph, so
/// layout and colour can be judged before we have photography. Swap for
/// `Image.asset(...)` per instance; nothing else in the tree changes.
class CraftImage extends StatelessWidget {
  const CraftImage({
    super.key,
    this.seed = 0,
    this.icon = Icons.auto_awesome_mosaic_outlined,
    this.borderRadius = Radii.md,
    this.asset,
    this.dim = false,
  });

  final int seed;
  final IconData icon;
  final BorderRadius borderRadius;
  final String? asset;

  /// Slightly desaturated, for "before" frames.
  final bool dim;

  static const _pairs = <List<Color>>[
    [Color(0xFFE8D9C4), Color(0xFFC9A87C)],
    [Color(0xFFE3C9B4), Color(0xFFB4866A)],
    [Color(0xFFD9C9AE), Color(0xFFA98F6B)],
    [Color(0xFFDCC6C0), Color(0xFFA9776C)],
    [Color(0xFFCBD3C4), Color(0xFF8A9A82)],
    [Color(0xFFD3D8E0), Color(0xFF7C8CA0)],
  ];

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(asset!, fit: BoxFit.cover),
      );
    }

    final pair = _pairs[seed % _pairs.length];
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dim
                ? [
                    Color.alphaBlend(const Color(0x33FFFFFF), pair[0]),
                    Color.alphaBlend(const Color(0x33FFFFFF), pair[1]),
                  ]
                : pair,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: AppColors.white.withValues(alpha: dim ? 0.35 : 0.5),
          ),
        ),
      ),
    );
  }
}
