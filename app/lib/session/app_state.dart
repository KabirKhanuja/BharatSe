import 'package:flutter/widgets.dart';
import '../l10n/lang.dart';
import '../l10n/strings.dart';
import 'link_state.dart';

/// Which experience the signed-in account gets.
///
/// One codebase, two very different products. The backend will decide this at
/// login; until then [AppState.signIn] stands in for it.
enum Role { buyer, seller }

/// App-wide state that is not owned by any single screen.
///
/// Kept deliberately small and dependency-free. When the backend lands, only
/// [signIn] and [signOut] change.
class AppState extends ChangeNotifier {
  AppState({Lang lang = Lang.en}) : _lang = lang;

  Lang _lang;
  Role _role = Role.buyer;
  bool _signedIn = false;
  String? _name;
  final Map<String, int> _cart = {'p1': 1, 'p3': 1};
  LinkState _link = LinkState.online;
  int _queued = 0;
  final Set<String> _saved = {};

  Lang get lang => _lang;
  AppStrings get s => AppStrings.of(_lang);
  Role get role => _role;
  bool get signedIn => _signedIn;
  String? get name => _name;
  Map<String, int> get cart => Map.unmodifiable(_cart);
  int get cartCount => _cart.values.fold(0, (a, b) => a + b);
  LinkState get link => _link;
  int get queued => _queued;
  Set<String> get saved => _saved;

  void setLang(Lang lang) {
    if (_lang == lang) return;
    _lang = lang;
    notifyListeners();
  }

  /// Stand-in for the real auth call. The role the backend returns is what
  /// decides whether this person sees a storefront or a listing tool.
  void signIn({required Role as, String name = 'Meena Chaudhary'}) {
    _signedIn = true;
    _role = as;
    _name = name;
    notifyListeners();
  }

  void signOut() {
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
    _link = state;
    _queued = state == LinkState.online ? 0 : 1;
    notifyListeners();
  }

  /// Development affordance so the offline story can be rehearsed on a desk.
  void cycleLink() {
    switch (_link) {
      case LinkState.online:
        _link = LinkState.offline;
        _queued = 1;
      case LinkState.offline:
        _link = LinkState.syncing;
      case LinkState.syncing:
        _link = LinkState.online;
        _queued = 0;
    }
    notifyListeners();
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
