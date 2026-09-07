import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/remote/firebase_config.dart';

/// Firebase sign in, wrapped so the rest of the app never imports Firebase.
///
/// Firebase only ever answers "who is this". What they are inside the product,
/// buyer or seller, verified or not, lives in Postgres and comes back from our
/// own API. Keeping that boundary means a future switch of identity provider
/// touches this file and nothing else.
class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? google})
      : _auth = auth ?? FirebaseAuth.instance,
        _google = google ??
            GoogleSignIn(
              // Without this Android has no audience to mint the ID token for,
              // and the whole thing fails as DEVELOPER_ERROR. See the comment
              // on googleServerClientId.
              serverClientId: googleServerClientId,
              scopes: const ['email', 'profile'],
            );

  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;

  /// The token we hand to our API. Firebase refreshes it automatically, so this
  /// is read fresh each time rather than cached.
  Future<String?> idToken({bool forceRefresh = false}) =>
      _auth.currentUser?.getIdToken(forceRefresh) ?? Future.value(null);

  Future<String> signInWithGoogle() async {
    debugPrint('[auth] google signIn starting');

    // Google caches the last account and reuses it silently, so the chooser
    // only ever appears once per device. Sign out of Google first so the person
    // can pick, which matters here because buyer and seller are separate
    // accounts and role is fixed at sign up.
    try {
      await _google.signOut();
    } catch (_) {
      // Nothing was signed in. Fine.
    }

    final GoogleSignInAccount? account;
    try {
      account = await _google.signIn();
    } catch (error, stack) {
      // google_sign_in throws PlatformException for configuration problems and
      // they are indistinguishable from a cancel at the call site, so log the
      // real thing before it gets turned into a friendly message.
      debugPrint('[auth] google signIn threw: $error');
      debugPrint('$stack');
      rethrow;
    }

    if (account == null) {
      debugPrint('[auth] google signIn returned null (cancelled or blocked)');
      throw const AuthCancelled();
    }

    debugPrint('[auth] google account: ${account.email}');
    final auth = await account.authentication;
    debugPrint('[auth] idToken present: ${auth.idToken != null}, '
        'accessToken present: ${auth.accessToken != null}');
    if (auth.idToken == null) {
      // Reaching here means the serverClientId is wrong or missing rather than
      // anything the user did, so say so plainly instead of "try again".
      throw StateError(
        'Google returned no ID token. Check serverClientId matches the web '
        'OAuth client in google-services.json.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    debugPrint('[auth] firebase uid: ${result.user?.uid}');
    return await result.user!.getIdToken() ?? '';
  }

  Future<String> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return await result.user!.getIdToken() ?? '';
  }

  Future<String> signUpWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (name != null && name.isNotEmpty) {
      await result.user!.updateDisplayName(name);
    }
    return await result.user!.getIdToken() ?? '';
  }

  Future<void> signOut() async {
    // Sign out of Google too, or the next tap silently reuses the same account
    // and the chooser never appears.
    await Future.wait([_auth.signOut(), _google.signOut()]);
  }

  /// Turn Firebase's error codes into something an artisan can act on.
  static String messageFor(Object error) {
    if (error is AuthCancelled) return '';
    if (error is! FirebaseAuthException) return 'Something went wrong. Try again.';

    return switch (error.code) {
      'invalid-email' => 'That email address does not look right.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
        'That email or password is not right.',
      'email-already-in-use' => 'This email already has an account. Sign in instead.',
      'weak-password' => 'Use a longer password, at least six characters.',
      'network-request-failed' => 'No internet. Try again when you have signal.',
      'too-many-requests' => 'Too many attempts. Wait a minute and try again.',
      _ => 'Could not sign you in. Try again.',
    };
  }
}

/// The user dismissed the Google sheet. Distinct from a failure, because it
/// should not surface an error message.
class AuthCancelled implements Exception {
  const AuthCancelled();
}
