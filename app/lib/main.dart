import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/buyer/buyer_shell.dart';
import 'l10n/lang.dart';
import 'features/seller/seller_shell.dart';
import 'session/app_state.dart';
import 'session/link_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlay);
  runApp(const BharatSeApp());
}

class BharatSeApp extends StatefulWidget {
  const BharatSeApp({super.key});

  @override
  State<BharatSeApp> createState() => _BharatSeAppState();
}

class _BharatSeAppState extends State<BharatSeApp> {
  late final AppState _state = AppState(
    lang: const String.fromEnvironment('LANG') == 'hi' ? Lang.hi : Lang.en,
  )
    ..cycleLinkTo(const bool.fromEnvironment('OFFLINE')
        ? LinkState.offline
        : LinkState.online);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'BharatSe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final app = context.app;

    // One codebase, two products. The backend will set the role at login.
    final shell = switch (app.role) {
      Role.buyer => BuyerShell(onSwitchToSeller: () => app.setRole(Role.seller)),
      Role.seller => SellerShell(onSwitchToBuyer: () => app.setRole(Role.buyer)),
    };

    return _PhoneFrame(
      child: Stack(
        children: [
          shell,
          // Development affordance: flips the connection state without a radio
          // so the offline story can be rehearsed at a desk. Remove before demo.
          Positioned(
            right: 8,
            bottom: 96,
            child: Opacity(
              opacity: 0.55,
              child: FloatingActionButton.small(
                heroTag: 'linktoggle',
                onPressed: app.cycleLink,
                child: const Icon(Icons.wifi_tethering_rounded, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps the app at a phone width when it is running in a desktop browser, so
/// what we review is what a phone actually shows. No effect on a real device.
class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});
  final Widget child;

  static const _phoneWidth = 412.0;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w <= _phoneWidth + 24) return child;

    return ColoredBox(
      color: const Color(0xFFE9E3DA),
      child: Center(
        child: SizedBox(width: _phoneWidth, child: ClipRect(child: child)),
      ),
    );
  }
}
