import 'package:flutter/material.dart';
import '../../data/catalog.dart';
import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/offline.dart';
import '../../widgets/top_bar.dart';
import 'explore/explore_screen.dart';
import 'home/home_screen.dart';
import 'product/product_screen.dart';
import 'profile/profile_screen.dart';

/// The buyer product. Three tabs, with cart and search in the header.
class BuyerShell extends StatefulWidget {
  const BuyerShell({super.key, this.onSwitchToSeller});
  final VoidCallback? onSwitchToSeller;

  @override
  State<BuyerShell> createState() => _BuyerShellState();
}

class _BuyerShellState extends State<BuyerShell> {
  // Dev affordance: --dart-define=TAB=1 opens straight to a given tab, so a
  // screen can be reviewed or captured without clicking through.
  int _tab = const int.fromEnvironment('TAB');

  void _openProduct(Product p) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductScreen(product: p)),
    );
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
            TopBar(showTagline: _tab != 2),
            ConnectionStrip(state: app.link, queued: app.queued),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  HomeScreen(
                    onExplore: () => setState(() => _tab = 1),
                    onProduct: _openProduct,
                    onState: (_) => setState(() => _tab = 1),
                  ),
                  const ExploreScreen(),
                  ProfileScreen(onSwitchToSeller: widget.onSwitchToSeller),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: s.navHome,
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: s.navExplore,
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: s.navProfile,
                  selected: _tab == 2,
                  onTap: () => setState(() => _tab = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.navy : AppColors.inkFaint;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppText.navLabel.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
