import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The gold rule with a small floret at its centre. Used under page titles.
class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key, this.width = 120, this.color = AppColors.gold});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.55))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.spa_outlined, size: 11, color: color),
          ),
          Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.55))),
        ],
      ),
    );
  }
}

/// A short gold rule with no floret. Sits under Hindi hero headlines.
class GoldRule extends StatelessWidget {
  const GoldRule({super.key, this.width = 56});
  final double width;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: 1.5,
        color: AppColors.gold.withValues(alpha: 0.8),
      );
}
