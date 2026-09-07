import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bharatse/data/remote/api_client.dart';
import 'package:bharatse/data/remote/api_models.dart';
import 'package:bharatse/session/app_state.dart';

/// Verification gates the whole seller product, so getting the state wrong
/// either locks out a verified artisan or lets an unverified one list.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VerificationState', () {
    test('maps the states the API sends', () {
      expect(VerificationState.fromApi('approved'), VerificationState.approved);
      expect(VerificationState.fromApi('pending'), VerificationState.pending);
      expect(
        VerificationState.fromApi('not_submitted'),
        VerificationState.notSubmitted,
      );
    });

    test('anything unrecognised is treated as not submitted, never approved',
        () {
      // Failing open here would let an unverified artisan list products.
      expect(VerificationState.fromApi(''), VerificationState.notSubmitted);
      expect(VerificationState.fromApi('nonsense'), VerificationState.notSubmitted);
      expect(VerificationState.fromApi('APPROVED'), VerificationState.notSubmitted);
    });

    test('only approved can sell', () {
      expect(VerificationState.approved.canSell, isTrue);
      expect(VerificationState.pending.canSell, isFalse);
      expect(VerificationState.notSubmitted.canSell, isFalse);
    });
  });

  group('refreshVerification', () {
    AppState stateWith(MockClient client) => AppState(api: ApiClient(client: client));

    MockClient serving(Map<String, dynamic> status) => MockClient((request) async {
          if (request.url.path.endsWith('/auth/otp/verify')) {
            return http.Response(
              jsonEncode({
                'access_token': 'tok',
                'token_type': 'bearer',
                'role': 'artisan',
                'user_id': 'u1',
                'name': 'A',
              }),
              200,
            );
          }
          return http.Response(jsonEncode(status), 200);
        });

    test('starts locked before anything is known', () {
      final state = stateWith(serving(const {}));
      expect(state.verification.state.canSell, isFalse);
    });

    test('an approved artisan is unlocked', () async {
      final state = stateWith(serving(const {
        'submitted': true,
        'is_verified': true,
        'state': 'approved',
      }));

      await state.refreshVerification();
      expect(state.verification.state, VerificationState.approved);
      expect(state.verification.state.canSell, isTrue);
    });

    test('a pending artisan stays locked', () async {
      final state = stateWith(serving(const {
        'submitted': true,
        'is_verified': false,
        'state': 'pending',
      }));

      await state.refreshVerification();
      expect(state.verification.state, VerificationState.pending);
      expect(state.verification.state.canSell, isFalse);
    });

    test('offline keeps the last known state rather than locking her out',
        () async {
      final state = stateWith(serving(const {
        'submitted': true,
        'is_verified': true,
        'state': 'approved',
      }));
      await state.refreshVerification();
      expect(state.verification.state.canSell, isTrue);

      // Same object, now unreachable.
      state.api.close();
      final offline = AppState(
        api: ApiClient(
          client: MockClient((_) async => throw http.ClientException('down')),
        ),
      );
      await offline.refreshVerification();

      // Never approved, so it stays locked, and it does not throw.
      expect(offline.verification.state.canSell, isFalse);
    });

    test('signing out clears the approval', () async {
      final state = stateWith(serving(const {
        'submitted': true,
        'is_verified': true,
        'state': 'approved',
      }));
      await state.refreshVerification();
      expect(state.verification.state.canSell, isTrue);

      state.signOut();
      expect(state.verification.state.canSell, isFalse);
    });
  });
}
