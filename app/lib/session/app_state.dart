import 'package:flutter/widgets.dart';

import '../data/remote/api_client.dart';
import '../data/remote/api_models.dart';
import '../l10n/lang.dart';
import '../l10n/strings.dart';
import '../services/auth_service.dart';
import '../services/capture_service.dart';
import '../data/local/outbox_repository.dart';
import '../data/local/product_store.dart';
import '../services/sync_service.dart';
import 'link_state.dart';

/// Which experience the signed-in account gets.
///
/// One codebase, two very different products. The backend will decide this at
/// login; until then [AppState.signIn] stands in for it.
enum Role {
  buyer,
  seller;

  /// The API calls a seller an artisan. Translate in one place rather than
  /// scattering the mismatch, and default to buyer for anything unrecognised so
  /// an unknown role can never be handed the listing tools.
  static Role fromApi(String value) =>
      switch (value.toLowerCase()) { 'artisan' || 'seller' => Role.seller, _ => Role.buyer };

  String get apiValue => this == Role.seller ? 'artisan' : 'buyer';
}

/// App-wide state that is not owned by any single screen.
///
/// Kept deliberately small and dependency-free. When the backend lands, only
/// [signIn] and [signOut] change.
class AppState extends ChangeNotifier {
  AppState({
    Lang lang = Lang.en,
    ApiClient? api,
    CaptureService? capture,
    SyncService? sync,
  })  : _lang = lang,
        api = api ?? ApiClient(),
        _capture = capture {
    this.sync = sync ?? SyncService(api: this.api, outbox: MemoryOutboxStore());
    this.sync.addListener(notifyListeners);
  }

  final ApiClient api;

  /// Built on first use, not at startup. Constructing it opens a platform
  /// channel to the recorder, which a buyer who never touches the microphone
  /// has no reason to pay for.
  CaptureService? _capture;
  CaptureService get capture => _capture ??= CaptureService();

  AuthService? _auth;
  AuthService get auth => _auth ??= AuthService();
  set auth(AuthService value) => _auth = value;

  /// Whether the landing screen should still be showing.
  ///
  /// Separate from [signedIn] so a cold start can hold the video on screen
  /// while we exchange a restored Firebase session for our own token, rather
  /// than flashing the landing page and then jumping away from it.
  bool _bootstrapping = true;
  bool get bootstrapping => _bootstrapping;

  void finishBootstrap() {
    if (!_bootstrapping) return;
    _bootstrapping = false;
    notifyListeners();
  }

  /// Sign in through Firebase, then exchange that for our own token.
  ///
  /// The role we send is a request, not a decision: the server only applies it
  /// when creating the account. Whatever comes back is what this person
  /// actually is, and that is what the app routes on.
  Future<void> completeSignIn({
    required String idToken,
    required Role wants,
    String name = '',
    bool create = true,
  }) async {
    final token = await api.signInWithFirebase(
      idToken: idToken,
      role: wants.apiValue,
      name: name,
      create: create,
    );

    signIn(
      as: Role.fromApi(token.role),
      name: token.name.isEmpty ? name : token.name,
      token: token.accessToken,
    );

    if (role == Role.seller) await refreshVerification();
  }

  /// Restore a session on a cold start, if Firebase still has one.
  ///
  /// Deliberately never creates an account. A Firebase session can outlive the
  /// account it belonged to, or exist before one was ever made, and guessing a
  /// role here would fix it permanently to whatever we guessed. If the server
  /// has no account, drop the stale Firebase session and let the landing screen
  /// ask properly.
  Future<void> restoreSession() async {
    try {
      final idToken = await auth.idToken();
      if (idToken != null && idToken.isNotEmpty) {
        await completeSignIn(
          idToken: idToken,
          wants: Role.buyer,
          create: false,
        );
      }
    } on ApiException catch (error) {
      if (error.statusCode == 404) await auth.signOut();
    } catch (_) {
      // No session, or no signal. The landing screen handles both.
    } finally {
      finishBootstrap();
    }
  }

  Future<void> signOutEverywhere() async {
    await auth.signOut();
    signOut();
  }
  late SyncService sync;
  ProductStore products = MemoryProductStore();

  /// Where this artisan stands in identity review.
  ///
  /// Held here rather than fetched per screen, because both the shell and the
  /// verification screen switch on it and they must never disagree.
  VerificationStatus _verification = VerificationStatus.unknown;
  VerificationStatus get verification => _verification;

  /// Ask the server. Silent on failure: with no signal the last known state is
  /// better than bouncing her out of a screen she is halfway through.
  Future<void> refreshVerification() async {
    if (!await ensureSession()) return;
    try {
      _verification = await api.verificationStatus();
      notifyListeners();
    } on ApiException {
      // Keep what we had.
    }
  }

  void attachProducts(ProductStore store) {
    products = store;
    notifyListeners();
  }

  /// Swap in the durable outbox once it has opened. Done after construction so
  /// nothing blocks the first frame on disk IO.
  void attachSync(SyncService service) {
    sync.removeListener(notifyListeners);
    sync = service;
    sync.addListener(notifyListeners);
    notifyListeners();
  }

  Lang _lang;
  Role _role = Role.buyer;
  bool _signedIn = false;
  String? _name;
  final Map<String, int> _cart = {'p1': 1, 'p3': 1};
  final Set<String> _saved = {};

  Lang get lang => _lang;
  AppStrings get s => AppStrings.of(_lang);
  Role get role => _role;
  bool get signedIn => _signedIn;
  String? get name => _name;
  Map<String, int> get cart => Map.unmodifiable(_cart);
  int get cartCount => _cart.values.fold(0, (a, b) => a + b);
  LinkState get link => sync.link;
  int get queued => sync.pending;
  Set<String> get saved => _saved;

  void setLang(Lang lang) {
    if (_lang == lang) return;
    _lang = lang;
    notifyListeners();
  }

  /// Stand-in for the real auth call. The role the backend returns is what
  /// decides whether this person sees a storefront or a listing tool.
  /// Phone number the prototype signs in as.
  ///
  /// Stable rather than random, so the same artisan and her catalogue survive a
  /// reinstall. Google sign in replaces this method and nothing downstream
  /// changes, because the rest of the app only ever cares about the token and
  /// the role.
  static const demoPhone = '9000000001';
  static const demoOtp = '123456';

  bool _authenticating = false;

  /// Get a token if we do not have one.
  ///
  /// Called before anything that needs the server. Failure is deliberately
  /// silent: with no signal there is no token to be had, and the outbox already
  /// holds the work until there is.
  Future<bool> ensureSession() async {
    if (api.isAuthenticated) return true;
    if (_authenticating) return false;

    _authenticating = true;
    try {
      final token = await api.verifyOtp(demoPhone, demoOtp);
      signIn(
        as: Role.fromApi(token.role),
        name: token.name.isEmpty ? 'Artisan' : token.name,
        token: token.accessToken,
      );
      return true;
    } on ApiException {
      return false;
    } finally {
      _authenticating = false;
    }
  }

  void signIn({required Role as, String name = 'Meena Chaudhary', String? token}) {
    if (token != null) api.token = token;
    _signedIn = true;
    _role = as;
    _name = name;
    notifyListeners();
  }

  void signOut() {
    api.token = null;
    _verification = VerificationStatus.unknown;
    _signedIn = false;
    _role = Role.buyer;
    _name = null;
    notifyListeners();
  }

  void setRole(Role role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  void toggleSaved(String productId) {
    _saved.contains(productId) ? _saved.remove(productId) : _saved.add(productId);
    notifyListeners();
  }

  bool isSaved(String productId) => _saved.contains(productId);

  void addToCart(String productId) {
    _cart.update(productId, (q) => q + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void setQty(String productId, int qty) {
    if (qty <= 0) {
      _cart.remove(productId);
    } else {
      _cart[productId] = qty;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  /// Sets the connection state directly. Used at startup and by tests.
  void cycleLinkTo(LinkState state) {
    sync.forceLink(state);
  }

  /// Development affordance so the offline story can be rehearsed on a desk.
  void cycleLink() {
    sync.forceLink(switch (sync.link) {
      LinkState.online => LinkState.offline,
      LinkState.offline => LinkState.syncing,
      LinkState.syncing => LinkState.online,
    });
  }
}

/// Exposes [AppState] to the tree. `context.app` and `context.s` read it.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found above this widget');
    return scope!.notifier!;
  }
}

extension AppContext on BuildContext {
  AppState get app => AppScope.of(this);
  AppStrings get s => AppScope.of(this).s;
  Lang get lang => AppScope.of(this).lang;
}
