import 'package:flutter/material.dart';
import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import 'add_product_screen.dart';

/// The artisan product. Currently the listing flow only; the seller home,
/// orders inbox and earnings views come next.
///
/// Localisation here still needs doing: these screens are Hindi-first because
/// that is the user, while the buyer side defaults to English.
class SellerShell extends StatelessWidget {
  const SellerShell({super.key, this.onSwitchToBuyer});
  final VoidCallback? onSwitchToBuyer;

  @override
  Widget build(BuildContext context) {
    final app = context.app;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: AddProductScreen(link: app.link, queued: app.queued),
      bottomNavigationBar: onSwitchToBuyer == null
          ? null
          : Material(
              color: AppColors.cream,
              child: InkWell(
                onTap: onSwitchToBuyer,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Gap.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.swap_horiz_rounded,
                            size: 16, color: AppColors.inkMuted),
                        const SizedBox(width: Gap.sm),
                        Text('Back to buyer view',
                            style: AppText.body(12.5,
                                weight: FontWeight.w500,
                                color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
