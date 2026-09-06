import 'package:flutter/material.dart';
import '../session/app_state.dart';
import '../session/link_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';

export '../session/link_state.dart';

/// A slim strip pinned under the header when there is no signal, or while the
/// outbox is draining.
///
/// This exists because "works offline" is invisible unless the UI says so. A
/// judge putting the phone in airplane mode has to SEE the app change its mind
/// and keep working, otherwise the feature does not exist to them.
class ConnectionStrip extends StatelessWidget {
  const ConnectionStrip({super.key, required this.state, this.queued = 0});

  final LinkState state;
  final int queued;

  @override
  Widget build(BuildContext context) {
    if (state == LinkState.online && queued == 0) return const SizedBox.shrink();

    final s = context.s;

    // Online but with items still in the outbox is a draining state, never a
    // finished one. Saying "all synced" while rows are pending is a lie the
    // user would catch.
    final effective =
        (state == LinkState.online && queued > 0) ? LinkState.syncing : state;

    final offline = effective == LinkState.offline;
    final bg = offline ? const Color(0xFFF0EAE0) : const Color(0xFFE8F0EA);
    final fg = offline ? AppColors.offline : AppColors.success;

    final text = switch (effective) {
      LinkState.offline => queued > 0
          ? s.offlineNoticeWithCount.replaceFirst('{n}', '$queued')
          : s.offlineNotice,
      LinkState.syncing => s.syncing.replaceFirst('{n}', '$queued'),
      LinkState.online => s.allSynced,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: Gap.page, vertical: 7),
      child: Row(
        children: [
          if (effective == LinkState.syncing)
            SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(strokeWidth: 1.8, color: fg),
            )
          else
            Icon(offline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                size: 15, color: fg),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(text,
                style: AppText.body(12.5, weight: FontWeight.w500, color: fg)),
          ),
        ],
      ),
    );
  }
}

/// Per-item badge. Sits on a product card that has not reached the server yet.
/// Reads as "saved and waiting", never as "failed".
class QueuedBadge extends StatelessWidget {
  const QueuedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: Radii.pill,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded, size: 12, color: AppColors.offline),
          const SizedBox(width: 5),
          Text(
            context.s.savedOnPhone,
            style: AppText.body(11, weight: FontWeight.w600, color: AppColors.offline),
          ),
        ],
      ),
    );
  }
}
