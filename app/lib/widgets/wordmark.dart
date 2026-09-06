import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum Script { devanagari, latin }

/// The BharatSe wordmark, with the terracotta dot that sits above the final
/// glyph in both scripts. Tagline is optional so the compact header can drop it.
class Wordmark extends StatelessWidget {
  const Wordmark({
    super.key,
    this.script = Script.latin,
    this.size = 26,
    this.showTagline = true,
    this.color = AppColors.navy,
  });

  final Script script;
  final double size;
  final bool showTagline;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isHi = script == Script.devanagari;
    final mark = isHi ? 'भारतसे' : 'BharatSe';
    final tagline =
        isHi ? 'भारत के लोगों से, भारत के लिए' : 'From the people of Bharat, for Bharat';

    final style = isHi
        ? AppText.hi(size, weight: 700, color: color, height: 1.1)
        : AppText.en(size, weight: 600, color: color, height: 1.1);

    // The dot rides above the trailing glyph. Offsets are tuned per script
    // because the two families have different cap and matra heights.
    final dotSize = size * 0.135;
    final dotRight = isHi ? size * 0.10 : size * 0.085;
    final dotTop = isHi ? -size * 0.30 : -size * 0.06;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            Text(mark, style: style),
            Positioned(
              right: dotRight,
              top: dotTop,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: const BoxDecoration(
                  color: AppColors.terracotta,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: size * 0.14),
          Text(
            tagline,
            style: AppText.body(
              size * 0.36,
              color: AppColors.terracotta,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
