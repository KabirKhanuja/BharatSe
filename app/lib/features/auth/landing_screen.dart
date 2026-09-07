import 'package:flutter/material.dart';

import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import 'sign_in_screen.dart';
import 'video_backdrop.dart';

/// The first thing anyone sees.
///
/// Asks one question, because it is the only one that changes what happens
/// next: are you here to buy, or do you make things. Everything after it is
/// shaped by that answer.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _choose(BuildContext context, Role role) {
    Navigator.of(context).push(
      PageRouteBuilder(
        // Fade rather than slide, so the film behind does not appear to move.
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (_, __, ___) => SignInScreen(wants: role),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final hi = context.lang.name == 'hi';

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: VideoBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xxl, Gap.xl, Gap.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'BharatSe',
                  style: AppText.en(44, weight: 600, color: AppColors.white, height: 1.0),
                ),
                const SizedBox(height: Gap.md),
                Text(
                  s.landingTagline,
                  style: hi
                      ? AppText.hi(17, weight: 500, color: AppColors.cream, height: 1.5)
                      : AppText.body(16,
                          color: AppColors.cream.withValues(alpha: 0.9), height: 1.4),
                ),
                const Spacer(),

                _ChoiceCard(
                  title: s.continueAsSeller,
                  blurb: s.sellerBlurb,
                  icon: Icons.handyman_outlined,
                  filled: true,
                  onTap: () => _choose(context, Role.seller),
                ),
                const SizedBox(height: Gap.md),
                _ChoiceCard(
                  title: s.continueAsBuyer,
                  blurb: s.buyerBlurb,
                  icon: Icons.storefront_outlined,
                  filled: false,
                  onTap: () => _choose(context, Role.buyer),
                ),
                const SizedBox(height: Gap.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.blurb,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String title;
  final String blurb;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? AppColors.white : AppColors.cream;

    return Material(
      color: filled ? AppColors.maroon : AppColors.white.withValues(alpha: 0.10),
      borderRadius: Radii.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.md,
        child: Container(
          padding: const EdgeInsets.all(Gap.lg),
          decoration: BoxDecoration(
            borderRadius: Radii.md,
            border: filled
                ? null
                : Border.all(color: AppColors.white.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: foreground),
              const SizedBox(width: Gap.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppText.body(16.5,
                            weight: FontWeight.w600, color: foreground)),
                    const SizedBox(height: 3),
                    Text(blurb,
                        style: AppText.body(12.5,
                            color: foreground.withValues(alpha: 0.75), height: 1.3)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, size: 19, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
