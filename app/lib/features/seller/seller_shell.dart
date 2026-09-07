import 'package:flutter/material.dart';

import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import '../../widgets/offline.dart';
import '../../widgets/wordmark.dart';
import 'add_product_screen.dart';
import 'home/seller_home_screen.dart';
import 'reach/reach_screen.dart';
import 'verification/verification_screen.dart';

/// The artisan product.
///
/// Two places to be: her catalogue, and adding to it. Everything else an
/// artisan needs is inside those two.
class SellerShell extends StatefulWidget {
  const SellerShell({super.key});

  @override
  State<SellerShell> createState() => _SellerShellState();
}

class _SellerShellState extends State<SellerShell> {
  final _homeKey = GlobalKey<State<SellerHomeScreen>>();

  @override
  void initState() {
    super.initState();
    // Ask once on entry rather than polling. Approval is a human action that
    // takes hours, so anything more frequent is wasted requests.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.app.refreshVerification(),
    );
  }

  Future<void> _openAddProduct() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    // Coming back from the flow should show what was just added.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;

    // Nothing below this line is reachable until a ministry officer has
    // approved her. Listing under an unverified identity is the thing the
    // Craft Passport exists to make impossible.
    if (!app.verification.state.canSell) {
      return VerificationScreen(
        onApproved: () => setState(() {}),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.sm, Gap.sm, Gap.md),
              child: Row(
                children: [
                  const Expanded(child: Wordmark(size: 23, showTagline: true)),
                  IconButton(
                    tooltip: s.reachTitle,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReachScreen()),
                    ),
                    icon: const Icon(Icons.campaign_outlined),
                    color: AppColors.terracotta,
                  ),
                  IconButton(
                    tooltip: s.signOut,
                    onPressed: () => context.app.signOutEverywhere(),
                    icon: const Icon(Icons.logout_rounded),
                    color: AppColors.inkMuted,
                  ),
                ],
              ),
            ),
            ConnectionStrip(state: app.link, queued: app.queued),
            Expanded(
              child: SellerHomeScreen(key: _homeKey, onAdd: _openAddProduct),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddProduct,
        backgroundColor: AppColors.maroon,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_a_photo_outlined, size: 20),
        label: Text(s.addProduct,
            style: AppText.body(14.5,
                weight: FontWeight.w600, color: AppColors.white)),
      ),
    );
  }
}
