import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bharatse/data/remote/api_client.dart';
import 'package:bharatse/session/app_state.dart';

/// Without a token every seller endpoint returns 401, which the app reads as a
/// network failure. These tests exist so that cannot regress silently.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Role.fromApi', () {
    test('the API says artisan where the app says seller', () {
      expect(Role.fromApi('artisan'), Role.seller);
      expect(Role.fromApi('seller'), Role.seller);
      expect(Role.fromApi('ARTISAN'), Role.seller);
    });

    test('buyer stays buyer', () {
      expect(Role.fromApi('buyer'), Role.buyer);
    });

    test('anything unrecognised falls back to buyer, never to seller', () {
      // An unknown role must not be handed the listing tools.
      expect(Role.fromApi('officer'), Role.buyer);
      expect(Role.fromApi(''), Role.buyer);
      expect(Role.fromApi('nonsense'), Role.buyer);
    });

    test('round trips back to the name the API uses', () {
      expect(Role.seller.apiValue, 'artisan');
      expect(Role.buyer.apiValue, 'buyer');
    });
  });

  group('ensureSession', () {
    AppState stateWith(MockClient client) =>
        AppState(api: ApiClient(client: client));

    test('signs in and holds the token', () async {
      var calls = 0;
      final state = stateWith(MockClient((request) async {
        calls++;
        return http.Response(
          jsonEncode({
            'access_token': 'tok',
            'token_type': 'bearer',
            'role': 'artisan',
            'user_id': 'u1',
            'name': 'Meena Chaudhary',
          }),
          200,
        );
      }));

      expect(await state.ensureSession(), isTrue);
      expect(state.api.isAuthenticated, isTrue);
      expect(state.role, Role.seller);
      expect(state.name, 'Meena Chaudhary');
      expect(calls, 1);
    });

    test('does not sign in twice', () async {
      var calls = 0;
      final state = stateWith(MockClient((_) async {
        calls++;
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
      }));

      await state.ensureSession();
      await state.ensureSession();
      expect(calls, 1, reason: 'a held token must be reused');
    });

    test('offline fails quietly rather than throwing', () async {
      final state = stateWith(
        MockClient((_) async => throw http.ClientException('unreachable')),
      );

      // With no signal there is no token to be had. The outbox holds the work.
      expect(await state.ensureSession(), isFalse);
      expect(state.api.isAuthenticated, isFalse);
    });

    test('a rejected code fails quietly too', () async {
      final state = stateWith(MockClient((_) async => http.Response(
            jsonEncode({'code': 'unauthorized', 'message': 'Incorrect code'}),
            401,
          )));

      expect(await state.ensureSession(), isFalse);
      expect(state.api.isAuthenticated, isFalse);
    });

    test('signing out drops the token', () async {
      final state = stateWith(MockClient((_) async => http.Response(
            jsonEncode({
              'access_token': 'tok',
              'token_type': 'bearer',
              'role': 'artisan',
              'user_id': 'u1',
              'name': 'A',
            }),
            200,
          )));

      await state.ensureSession();
      state.signOut();
      expect(state.api.isAuthenticated, isFalse);
    });
  });
}
