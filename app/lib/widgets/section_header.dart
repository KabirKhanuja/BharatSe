import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';

/// "राज्य के अनुसार खोजें            सभी देखें >"
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.devanagari = true,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool devanagari;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: devanagari ? AppText.sectionTitleHi : AppText.sectionTitleEn,
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(actionLabel!, style: AppText.link),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.terracotta),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
