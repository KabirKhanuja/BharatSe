import 'package:flutter/material.dart';
import '../../../l10n/lang.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/language_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.controller, this.onSwitchToSeller});

  /// Owned by the shell so tapping the active tab can scroll it to the top.
  final ScrollController? controller;
  final VoidCallback? onSwitchToSeller;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = ProfileStrings.of(app.lang);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(
        Gap.page,
        Gap.sm,
        Gap.page,
        Gap.section,
      ),
      children: [
        _IdentityCard(),
        const SizedBox(height: Gap.xl),
        _Group(
          children: [
            _Tile(
              icon: Icons.receipt_long_outlined,
              label: s.myOrders,
              trailingText: '3',
            ),
            _Tile(
              icon: Icons.favorite_border_rounded,
              label: s.wishlist,
              trailingText: '${app.saved.length}',
            ),
            _Tile(icon: Icons.location_on_outlined, label: s.addresses),
          ],
        ),
        const SizedBox(height: Gap.lg),
        _Group(
          children: [
            _Tile(
              icon: Icons.translate_rounded,
              label: s.language,
              trailingText: app.lang.nativeName,
              onTap: () => showLanguageSheet(context),
            ),
            _Tile(icon: Icons.help_outline_rounded, label: s.help),
            _Tile(icon: Icons.info_outline_rounded, label: s.about),
          ],
        ),
        const SizedBox(height: Gap.xl),
        if (onSwitchToSeller != null) _SellerCard(onTap: onSwitchToSeller),
      ],
    );
  }

}

class _IdentityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = ProfileStrings.of(app.lang);
    final signedIn = app.signedIn;

    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.creamAlt,
            child: Icon(
              signedIn ? Icons.person_rounded : Icons.person_outline_rounded,
              color: AppColors.terracotta,
              size: 26,
            ),
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signedIn ? (app.name ?? '') : s.guestName,
                  style: AppText.body(16.5, weight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  signedIn ? '+91 98••• ••210' : s.guestSub,
                  style: AppText.caption,
                ),
              ],
            ),
          ),
          if (!signedIn)
            FilledButton(
              onPressed: () => app.signIn(as: Role.buyer),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
                shape: const RoundedRectangleBorder(borderRadius: Radii.sm),
              ),
              child: Text(
                s.signIn,
                style: AppText.body(
                  13.5,
                  weight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            )
          else
            IconButton(
              onPressed: app.signOutEverywhere,
              icon: const Icon(Icons.logout_rounded, size: 19),
              color: AppColors.inkMuted,
            ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, indent: 52, color: AppColors.line),
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.terracotta),
            const SizedBox(width: Gap.lg),
            Expanded(child: Text(label, style: AppText.body(14.5))),
            if (trailingText != null)
              Text(
                trailingText!,
                style: AppText.body(13.5, color: AppColors.inkMuted),
              ),
            const SizedBox(width: Gap.sm),
            const Icon(
              Icons.chevron_right_rounded,
              size: 19,
              color: AppColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}

/// The doorway between the two products. Login will eventually decide this;
/// during the demo it is an explicit switch.
class _SellerCard extends StatelessWidget {
  const _SellerCard({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = ProfileStrings.of(context.app.lang);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Gap.lg),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: Radii.md,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.12),
                borderRadius: Radii.sm,
              ),
              child: const Icon(
                Icons.storefront_outlined,
                color: AppColors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: Gap.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.switchToSeller,
                    style: AppText.body(
                      14.5,
                      weight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.sellerModeSub,
                    style: AppText.body(
                      12,
                      color: AppColors.white.withValues(alpha: 0.75),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
