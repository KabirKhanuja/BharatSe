import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';

/// A titled card. `icon` sits in a soft tinted square; `onEdit` renders the
/// pencil affordance; `onSpeak` renders the read-aloud button that every
/// content block needs, because our user may not read.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.iconColor = AppColors.terracotta,
    this.trailing,
    this.onEdit,
    this.onSpeak,
    this.padded = true,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onEdit;
  final VoidCallback? onSpeak;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      padding: EdgeInsets.all(padded ? Gap.md : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                padded ? 0 : Gap.md, padded ? 0 : Gap.md, padded ? 0 : Gap.md, 0),
            child: Row(
              children: [
                Icon(icon, size: 17, color: iconColor),
                const SizedBox(width: Gap.sm),
                Expanded(child: Text(title, style: AppText.label)),
                if (trailing != null) trailing!,
                if (onSpeak != null)
                  _IconTap(
                    icon: Icons.volume_up_rounded,
                    onTap: onSpeak!,
                    tooltip: 'सुनें',
                  ),
                if (onEdit != null)
                  _IconTap(
                    icon: Icons.edit_outlined,
                    onTap: onEdit!,
                    tooltip: 'बदलें',
                  ),
              ],
            ),
          ),
          SizedBox(height: padded ? Gap.md : Gap.md),
          child,
        ],
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({required this.icon, required this.onTap, required this.tooltip});
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.pill,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 17, color: AppColors.terracotta),
        ),
      ),
    );
  }
}
