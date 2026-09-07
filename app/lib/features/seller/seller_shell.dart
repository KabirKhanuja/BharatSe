import 'package:flutter/material.dart';

import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import '../../widgets/offline.dart';
import '../../widgets/wordmark.dart';
import 'add_product_screen.dart';
import 'home/seller_home_screen.dart';

/// The artisan product.
///
/// Two places to be: her catalogue, and adding to it. Everything else an
/// artisan needs is inside those two.
class SellerShell extends StatefulWidget {
  const SellerShell({super.key, this.onSwitchToBuyer});
  final VoidCallback? onSwitchToBuyer;

  @override
  State<SellerShell> createState() => _SellerShellState();
}

class _SellerShellState extends State<SellerShell> {
  final _homeKey = GlobalKey<State<SellerHomeScreen>>();

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
                    tooltip: s.switchToSeller,
                    onPressed: widget.onSwitchToBuyer,
                    icon: const Icon(Icons.swap_horiz_rounded),
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
