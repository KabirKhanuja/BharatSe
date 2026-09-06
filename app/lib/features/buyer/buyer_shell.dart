import 'package:flutter/material.dart';
import '../../data/catalog.dart';
import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/offline.dart';
import '../../widgets/top_bar.dart';
import 'cart/cart_screen.dart';
import 'explore/explore_screen.dart';
import 'state/state_screen.dart';
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

  /// Tabs are built the first time they are opened, then kept alive.
  /// IndexedStack builds every child eagerly, which would parse the whole
  /// India map at launch for a tab the user may never visit.
  late final Set<int> _built = {_tab};

  void _select(int i) => setState(() {
        _tab = i;
        _built.add(i);
      });

  void _openProduct(Product p) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductScreen(product: p)),
    );
  }

  void _openState(CraftState st) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StateScreen(state: st)),
    );
  }

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  Widget _lazy(int index, Widget Function() build) =>
      _built.contains(index) ? build() : const SizedBox.shrink();

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
            TopBar(showTagline: _tab != 2, onCart: _openCart),
            ConnectionStrip(state: app.link, queued: app.queued),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _lazy(
                    0,
                    () => HomeScreen(
                      onExplore: () => _select(1),
                      onProduct: _openProduct,
                      onState: _openState,
                    ),
                  ),
                  _lazy(1, () => ExploreScreen(onState: _openState)),
                  _lazy(
                    2,
                    () => ProfileScreen(
                        onSwitchToSeller: widget.onSwitchToSeller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: _select,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: s.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: s.navExplore,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: s.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

