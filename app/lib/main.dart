import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/add_product/add_product_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/offline.dart';

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
  // Temporary: lets us flip the app between online and offline without an
  // actual radio, so the airplane-mode story can be rehearsed on a desk.
  /// Build with --dart-define=OFFLINE=true to start in the no-signal state,
  /// so the airplane-mode story can be rehearsed without touching the radio.
  LinkState _link = const bool.fromEnvironment('OFFLINE')
      ? LinkState.offline
      : LinkState.online;

  void _cycle() => setState(() {
        _link = switch (_link) {
          LinkState.online => LinkState.offline,
          LinkState.offline => LinkState.syncing,
          LinkState.syncing => LinkState.online,
        };
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BharatSe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _PhoneFrame(
        child: Stack(
        children: [
          AddProductScreen(link: _link, queued: _link == LinkState.online ? 0 : 1),
          Positioned(
            right: 10,
            bottom: 92,
            child: Opacity(
              opacity: 0.65,
              child: FloatingActionButton.small(
                heroTag: 'linktoggle',
                onPressed: _cycle,
                child: const Icon(Icons.wifi_tethering_rounded, size: 18),
              ),
            ),
          ),
        ],
        ),
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
        child: SizedBox(
          width: _phoneWidth,
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
