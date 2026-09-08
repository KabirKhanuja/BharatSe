import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'data/catalog.dart';
import 'features/auth/landing_screen.dart';
import 'features/buyer/buyer_shell.dart';
import 'features/buyer/cart/cart_screen.dart';
import 'features/buyer/state/state_screen.dart';
import 'l10n/lang.dart';
import 'features/seller/seller_shell.dart';
import 'data/local/outbox_db.dart';
import 'data/local/outbox_repository.dart';
import 'data/local/product_store.dart';
import 'services/sync_service.dart';
import 'session/app_state.dart';
import 'session/link_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlay);

  // Firebase is not fatal. If it fails to start, the app still runs and the
  // landing screen simply cannot sign anyone in, which is a better outcome
  // than a white screen with no explanation.
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase failed to initialise: $error');
  }

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
  void initState() {
    super.initState();
    // Fire and forget. A suspended host takes about a minute to come back,
    // and starting that clock now means the wait happens behind the landing
    // screen instead of behind the sign in button.
    unawaited(_state.api.warmUp());
    _openDurableOutbox();
  }

  /// The queue starts in memory so the first frame is never blocked on disk,
  /// then swaps to the durable store as soon as it opens.
  Future<void> _openDurableOutbox() async {
    // One database instance for the whole app. Two of them over the same file
    // race and can corrupt it, which is the last thing the offline outbox
    // should be capable of doing.
    OutboxDb? db;
    if (!kIsWeb) {
      try {
        db = OutboxDb();
        _state.attachProducts(openProductStore(db: db));
      } catch (error) {
        debugPrint('Local database unavailable, using memory: $error');
        db = null;
      }
    }

    final store = await openOutboxStore(db);
    final sync = SyncService(
      api: _state.api,
      outbox: store,
      ensureSession: _state.ensureSession,
    );
    _state.attachSync(sync);

    // Adopt an existing Firebase session if there is one, so a returning user
    // lands where they left off instead of on the sign in screen.
    await _state.restoreSession();
    await sync.start();
  }

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

    // Screenshot and rehearsal harness: --dart-define=SCREEN=cart|state
    const screen = String.fromEnvironment('SCREEN');
    if (screen == 'cart') {
      return const _MaybeFramed(child: CartScreen());
    }
    if (screen == 'state') {
      return _MaybeFramed(child: StateScreen(state: Catalog.stateById('jk')));
    }

    // Hold the landing film while a restored session is exchanged for our own
    // token, so a returning user never sees the landing page flash past.
    if (app.bootstrapping) return const _Splash();

    // Nobody sees a product surface until they have said who they are.
    if (!app.signedIn) return const LandingScreen();

    // One codebase, two products. The role comes from Postgres, not from what
    // the app asked for at sign up.
    final shell = switch (app.role) {
      // No local role switch. Role is decided by the server at sign up, and
      // flipping it here only produces 403s from every seller endpoint.
      Role.buyer => const BuyerShell(),
      Role.seller => const SellerShell(),
    };

    return _MaybeFramed(
      child: Stack(
      children: [
        shell,
        // Development affordance: flips the connection state without a radio
        // so the offline story can be rehearsed at a desk. Hidden unless the
        // build asks for it: --dart-define=DEVTOOLS=true
        if (const bool.fromEnvironment('DEVTOOLS'))
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

/// Shown for the moment between launch and knowing whether there is a session.
/// Deliberately the landing film's own colours, so the transition into either
/// the landing screen or the app is not a flash of white.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Color(0xFF2A1B12),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
          ),
        ),
      );
}

/// Screenshot harness only. Chrome headless refuses windows narrower than
/// about 500px, so reviewing a phone layout in a browser needs the width
/// pinned. Off unless the build asks: --dart-define=FRAME=true
class _MaybeFramed extends StatelessWidget {
  const _MaybeFramed({required this.child});
  final Widget child;

  static const _phoneWidth = 412.0;

  @override
  Widget build(BuildContext context) {
    if (!const bool.fromEnvironment('FRAME')) return child;
    if (MediaQuery.sizeOf(context).width <= _phoneWidth + 24) return child;

    return ColoredBox(
      color: const Color(0xFFE9E3DA),
      child: Center(
        child: SizedBox(width: _phoneWidth, child: ClipRect(child: child)),
      ),
    );
  }
}
