import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bharatse/data/remote/api_client.dart';
import 'package:bharatse/data/remote/api_models.dart';

/// Pins the shape of what the API sends us.
///
/// The payloads below are copied from real responses. If the server renames a
/// field, one of these fails here rather than showing up as a null on stage.
void main() {
  test('price response parses, including the floor breakdown', () async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response(
            jsonEncode({
              'p10': 1120,
              'p50': 1389,
              'p90': 1792,
              'floor': 896,
              'breakdown': {
                'material_cost': 380,
                'labour_cost': 420,
                'overhead': 96,
                'floor': 896,
                'wage_per_hour': 60,
                'hours': 7.0,
              },
              'model_used': false,
              'lifted_to_floor': false,
              'note': 'Based on cost and a standard margin',
            }),
            200,
          )),
    );

    final band = await api.suggestPrice(hoursOfWork: 7, materialCost: 380);

    expect(band.floor, 896);
    expect(band.p10, 1120);
    expect(band.breakdown.labourCost, 420);
    expect(band.breakdown.wagePerHour, 60);
    expect(band.liftedToFloor, isFalse);
  });

  test('a band lifted to the floor is reported as such', () async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response(
            jsonEncode({
              'p10': 2240,
              'p50': 2240,
              'p90': 3000,
              'floor': 2240,
              'breakdown': {
                'material_cost': 380,
                'labour_cost': 1620,
                'overhead': 240,
                'floor': 2240,
                'wage_per_hour': 60,
                'hours': 27.0,
              },
              'model_used': true,
              'lifted_to_floor': true,
              'note': 'Raised to the fair wage floor',
            }),
            200,
          )),
    );

    final band = await api.suggestPrice(hoursOfWork: 27, materialCost: 380);
    expect(band.liftedToFloor, isTrue);
    expect(band.p10, band.floor);
  });

  test('auth token parses and is applied to later calls', () async {
    var sawAuthHeader = false;

    final api = ApiClient(
      client: MockClient((request) async {
        if (request.url.path.endsWith('/auth/otp/verify')) {
          return http.Response(
            jsonEncode({
              'access_token': 'abc123',
              'token_type': 'bearer',
              'role': 'artisan',
              'user_id': 'u1',
              'name': 'Meena Chaudhary',
            }),
            200,
          );
        }
        sawAuthHeader = request.headers['authorization'] == 'Bearer abc123';
        return http.Response(jsonEncode({'items': [], 'total': 0}), 200);
      }),
    );

    final token = await api.verifyOtp('9876543210', '123456');
    expect(token.role, 'artisan');
    expect(api.isAuthenticated, isTrue);

    await api.listProducts();
    expect(sawAuthHeader, isTrue);
  });

  test('a structured API error surfaces its message, not a status code',
      () async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'below_wage_floor',
              'message': 'A price of 100 is below the fair wage floor of 896.',
            }),
            422,
          )),
    );

    try {
      await api.suggestPrice(hoursOfWork: 7, materialCost: 380);
      fail('should have thrown');
    } on ApiException catch (error) {
      expect(error.statusCode, 422);
      expect(error.message, contains('fair wage floor'));
      expect(error.isOffline, isFalse);
    }
  });

  test('an unreachable server is flagged as offline, not as an error',
      () async {
    final api = ApiClient(
      client: MockClient((_) async => throw http.ClientException('failed')),
    );

    try {
      await api.suggestPrice(hoursOfWork: 7, materialCost: 380);
      fail('should have thrown');
    } on ApiException catch (error) {
      // This distinction decides whether the app queues the work or shows a
      // failure, so it matters more than the message does.
      expect(error.isOffline, isTrue);
    }
  });

  test('generated listing parses both languages and the transcript', () {
    final result = ListingResultParsing.parse({
      'listing': {
        'title_en': 'Handwoven silk scarf',
        'title_hi': 'हाथ से बुना रेशमी दुपट्टा',
        'description_en': 'A scarf.',
        'description_hi': 'एक दुपट्टा।',
        'tags': ['silk', 'scarf', 'handmade'],
        'materials': ['silk'],
        'technique': 'handwoven',
        'category': 'textiles',
        'estimated_hours': 7.0,
        'transcript': 'यह रेशमी दुपट्टा है',
        'detected_language': 'hi',
      },
      'provider': 'gemini',
    });

    expect(result.provider, 'gemini');
    expect(result.listing.titleHi, isNotEmpty);
    expect(result.listing.estimatedHours, 7.0);
    expect(result.listing.tags, hasLength(3));
  });

  test('listing images parse, and only the hero carries an enhanced url', () {
    final result = ListingImages.fromJson({
      'product_id': 'c0ffee00-0000-4000-8000-000000000001',
      'client_id': 'abc-123',
      'images': [
        {
          'position': 0,
          'original_url': 'https://x/o/p/original/b.jpg',
          'enhanced_url': 'https://x/o/p/enhanced/z.png',
          'is_hero': true,
        },
        {
          'position': 1,
          'original_url': 'https://x/o/p/original/a.jpg',
          'enhanced_url': null,
          'is_hero': false,
        },
      ],
      'hero_url': 'https://x/o/p/enhanced/z.png',
      'method': 'generative',
      'enhanced_count': 1,
    });

    expect(result.images, hasLength(2));
    expect(result.wasEnhanced, isTrue);
    // Exactly one photo carries a generated image, whatever the count. This is
    // the whole cost story of the feature in one assertion.
    expect(result.images.where((i) => i.enhancedUrl != null), hasLength(1));
    // The enhanced photo is stored first, so a consumer reading only the
    // primary image gets the good one.
    expect(result.hero!.position, 0);
    expect(result.heroUrl, endsWith('.png'));
  });

  test('an unreachable model still returns the artisan her own photo', () {
    // The server falls back rather than failing, so a listing is never
    // imageless because an API was down.
    final result = ListingImages.fromJson({
      'product_id': 'c0ffee00-0000-4000-8000-000000000002',
      'client_id': 'abc-124',
      'images': [
        {
          'position': 0,
          'original_url': 'https://x/o/p/original/only.jpg',
          'enhanced_url': null,
          'is_hero': true,
        },
      ],
      'hero_url': 'https://x/o/p/original/only.jpg',
      'method': 'none',
      'enhanced_count': 0,
    });

    expect(result.wasEnhanced, isFalse);
    expect(result.heroUrl, isNotEmpty);
  });
}

/// Small shim so the parsing above reads clearly.
extension ListingResultParsing on Object {
  static ListingResult parse(Map<String, dynamic> json) =>
      ListingResult.fromJson(json);
}
