import 'dart:convert';
import 'dart:io' show File, SocketException;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'api_models.dart';

/// The only place in the app that knows a URL exists.
///
/// Everything else calls methods here. That is deliberate: when the API adds
/// or renames a field, this file is the entire blast radius, and a contract
/// drift is one diff rather than a hunt through the widget tree.
class ApiClient {
  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? defaultBaseUrl,
        _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  String? _token;

  /// Android emulators reach the host machine on 10.0.2.2, never localhost.
  /// Override for a real device on wifi:
  ///   --dart-define=API_BASE_URL=http://192.168.1.x:8000
  static String get defaultBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;
    if (kIsWeb) return 'http://localhost:8000';
    return 'http://10.0.2.2:8000';
  }

  static const _prefix = '/api/v1';

  /// Short by design. An artisan on a thin connection should see the offline
  /// path take over rather than watch a spinner for a minute.
  static const _shortTimeout = Duration(seconds: 12);
  static const _uploadTimeout = Duration(seconds: 90);

  /// Image generation alone is tens of seconds, and this call also uploads
  /// every photo to storage first. The budget has to exceed what the server is
  /// willing to spend or the phone gives up on work that then completes and is
  /// thrown away, having already been paid for.
  static const _enhanceTimeout = Duration(seconds: 180);

  set token(String? value) => _token = value;
  bool get isAuthenticated => _token != null;

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        if (_token != null) 'authorization': 'Bearer $_token',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) => Uri.parse(
        '$baseUrl$_prefix$path',
      ).replace(
        queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
      );

  Never _fail(http.Response response) {
    String message = 'Request failed (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] is String) {
        message = body['message'] as String;
      } else if (body is Map && body['detail'] is Map) {
        message = '${(body['detail'] as Map)['message']}';
      }
    } catch (_) {
      // Body was not JSON. The status line is all we have.
    }
    throw ApiException(message, statusCode: response.statusCode);
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on SocketException catch (e) {
      throw ApiException('No connection', isOffline: true, cause: e);
    } on http.ClientException catch (e) {
      throw ApiException('No connection', isOffline: true, cause: e);
    }
  }

  // ------------------------------------------------------------------- auth
  Future<void> requestOtp(String phone) => _guard(() async {
        final response = await _client
            .post(_uri('/auth/otp/request'),
                headers: _headers, body: jsonEncode({'phone': phone}))
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);
      });

  Future<AuthToken> verifyOtp(String phone, String code) => _guard(() async {
        final response = await _client
            .post(_uri('/auth/otp/verify'),
                headers: _headers,
                body: jsonEncode({'phone': phone, 'code': code}))
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);

        final token = AuthToken.fromJson(jsonDecode(response.body));
        _token = token.accessToken;
        return token;
      });

  /// Exchange a Firebase ID token for one of ours.
  ///
  /// `role` is only honoured when the account is created. Sending a different
  /// one later does not change anything, because that would be a way around
  /// identity verification.
  Future<AuthToken> signInWithFirebase({
    required String idToken,
    required String role,
    String name = '',
    bool create = true,
  }) =>
      _guard(() async {
        final response = await _client
            .post(
              _uri('/auth/firebase'),
              headers: {'content-type': 'application/json'},
              body: jsonEncode({
                'id_token': idToken,
                'role': role,
                'name': name,
                'create': create,
              }),
            )
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);

        final token = AuthToken.fromJson(jsonDecode(response.body));
        _token = token.accessToken;
        return token;
      });

  // ---------------------------------------------------------------- listings
  /// She talks, this returns a finished listing in English and Hindi.
  ///
  /// `record` writes 16 kHz mono WAV, which is exactly what the server wants,
  /// so the bytes go up untouched. There is no conversion step in this app.
  Future<ListingResult> generateListing({
    required String audioPath,
    String? language,
  }) =>
      _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/listings/generate'))
          ..headers.addAll({if (_token != null) 'authorization': 'Bearer $_token'})
          ..files.add(await http.MultipartFile.fromPath(
            'audio',
            audioPath,
            // record writes 16 kHz mono WAV. Saying so matters because the
            // server hands the mime type straight to the model.
            contentType: MediaType('audio', 'wav'),
          ));

        if (language != null) request.fields['language'] = language;

        final streamed = await request.send().timeout(_uploadTimeout);
        final response = await http.Response.fromStream(streamed);
        if (response.statusCode >= 400) _fail(response);

        return ListingResult.fromJson(jsonDecode(response.body));
      });

  // ----------------------------------------------------------------- pricing
  Future<PriceBand> suggestPrice({
    required double hoursOfWork,
    required int materialCost,
    String category = 'other',
    String material = 'unknown',
    String technique = 'unknown',
    String stateCode = 'unknown',
    String title = '',
    String description = '',
  }) =>
      _guard(() async {
        final response = await _client
            .post(
              _uri('/pricing/suggest'),
              headers: _headers,
              body: jsonEncode({
                'category': category,
                'material': material,
                'technique': technique,
                'state_code': stateCode,
                'hours_of_work': hoursOfWork,
                'material_cost': materialCost,
                'title': title,
                'description': description,
              }),
            )
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);

        return PriceBand.fromJson(jsonDecode(response.body));
      });

  // ------------------------------------------------------------------ images
  /// Server side cutout, higher quality than the one the phone produced.
  Future<List<int>> cutout(String imagePath) => _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/images/cutout'))
          ..headers.addAll({if (_token != null) 'authorization': 'Bearer $_token'})
          ..files.add(await http.MultipartFile.fromPath(
            'image',
            imagePath,
            contentType: _mediaTypeFor(imagePath),
          ));

        final streamed = await request.send().timeout(_uploadTimeout);
        if (streamed.statusCode >= 400) {
          _fail(await http.Response.fromStream(streamed));
        }
        return streamed.stream.toBytes();
      });

  Future<List<int>> studio(String imagePath, {String aspect = 'square'}) =>
      _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/images/studio'))
          ..headers.addAll({if (_token != null) 'authorization': 'Bearer $_token'})
          ..fields['aspect'] = aspect
          ..files.add(await http.MultipartFile.fromPath(
            'image',
            imagePath,
            contentType: _mediaTypeFor(imagePath),
          ));

        final streamed = await request.send().timeout(_uploadTimeout);
        if (streamed.statusCode >= 400) {
          _fail(await http.Response.fromStream(streamed));
        }
        return streamed.stream.toBytes();
      });

  /// Every photo of one product, uploaded together, one of them enhanced.
  ///
  /// `clientId` is the same id the outbox will publish under. That is what
  /// attaches these images to the listing without either call knowing about the
  /// other: whichever arrives first creates the row, and the second fills in
  /// its half.
  ///
  /// `enhanceIndex` picks which photo the model runs on. The server enforces
  /// both the photo cap and the one-generation rule, so this is a request and
  /// not a promise.
  Future<ListingImages> enhanceListingImages({
    required List<String> imagePaths,
    required String clientId,
    String label = '',
    int enhanceIndex = 0,
  }) =>
      _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/images/listing'))
          ..headers.addAll({if (_token != null) 'authorization': 'Bearer $_token'})
          ..fields['client_id'] = clientId
          ..fields['label'] = label
          ..fields['enhance_index'] = '$enhanceIndex';

        for (final path in imagePaths) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            path,
            contentType: _mediaTypeFor(path),
          ));
        }

        final streamed = await request.send().timeout(_enhanceTimeout);
        final response = await http.Response.fromStream(streamed);
        if (response.statusCode >= 400) _fail(response);

        return ListingImages.fromJson(jsonDecode(response.body));
      });

  // ---------------------------------------------------------------- products
  Future<RemoteProduct> createProduct(Map<String, dynamic> body) =>
      _guard(() async {
        final response = await _client
            .post(_uri('/products'), headers: _headers, body: jsonEncode(body))
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);
        return RemoteProduct.fromJson(jsonDecode(response.body));
      });

  Future<List<RemoteProduct>> listProducts({int limit = 20, int offset = 0}) =>
      _guard(() async {
        final response = await _client
            .get(_uri('/products', {'limit': limit, 'offset': offset}),
                headers: _headers)
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);

        final items = (jsonDecode(response.body)['items'] as List?) ?? const [];
        return items
            .map((e) => RemoteProduct.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  /// Drain the phone's outbox. Upserts on client_id, so this is safe to retry.
  Future<SyncResult> syncProducts(List<Map<String, dynamic>> products) =>
      _guard(() async {
        final response = await _client
            .post(_uri('/products/sync'),
                headers: _headers, body: jsonEncode({'products': products}))
            .timeout(_uploadTimeout);
        if (response.statusCode >= 400) _fail(response);
        return SyncResult.fromJson(jsonDecode(response.body));
      });

  // ---------------------------------------------------------------- catalogue
  /// The public buyer catalogue. No auth: a shopper browsing has no account.
  Future<List<Map<String, dynamic>>> catalogProducts({
    int limit = 60,
    int offset = 0,
  }) =>
      _guard(() async {
        final response = await _client
            .get(_uri('/catalog/products', {'limit': limit, 'offset': offset}))
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);

        final items = (jsonDecode(response.body)['items'] as List?) ?? const [];
        return items.cast<Map<String, dynamic>>();
      });

  // ------------------------------------------------------------ verification
  Future<VerificationStatus> verificationStatus() => _guard(() async {
        final response = await _client
            .get(_uri('/verification/status'), headers: _headers)
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);
        return VerificationStatus.fromJson(jsonDecode(response.body));
      });

  /// Upload an identity document for review.
  ///
  /// Deliberately not queued through the outbox. Everything else an artisan
  /// does works offline, but this one cannot: there is nothing useful to show
  /// her until a human on the other end has looked at it.
  Future<void> submitVerification({
    required String documentPath,
    String stateCode = '',
    String craft = '',
    String district = '',
    String cluster = '',
  }) =>
      _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/verification/submit'))
          ..headers.addAll({if (_token != null) 'authorization': 'Bearer $_token'})
          ..files.add(await http.MultipartFile.fromPath(
            'document',
            documentPath,
            // MultipartFile does not infer this and defaults to
            // application/octet-stream, which any server checking content type
            // will reject.
            contentType: _mediaTypeFor(documentPath),
          ));

        if (stateCode.isNotEmpty) request.fields['state_code'] = stateCode;
        if (craft.isNotEmpty) request.fields['craft'] = craft;
        if (district.isNotEmpty) request.fields['district'] = district;
        if (cluster.isNotEmpty) request.fields['cluster'] = cluster;

        final streamed = await request.send().timeout(_uploadTimeout);
        final response = await http.Response.fromStream(streamed);
        if (response.statusCode >= 400) _fail(response);
      });

  // --------------------------------------------------------------- passports
  Future<PassportIssue> issuePassport(String productId) => _guard(() async {
        final response = await _client
            .post(_uri('/passports/$productId/issue'), headers: _headers)
            .timeout(_shortTimeout);
        if (response.statusCode >= 400) _fail(response);
        return PassportIssue.fromJson(jsonDecode(response.body));
      });

  Future<bool> health() async {
    try {
      final response =
          await _client.get(_uri('/health')).timeout(const Duration(seconds: 4));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void close() => _client.close();
}

/// Content type from the file extension, since MultipartFile will not do it.
MediaType _mediaTypeFor(String path) {
  final extension = path.toLowerCase().split('.').last;
  return switch (extension) {
    'png' => MediaType('image', 'png'),
    'pdf' => MediaType('application', 'pdf'),
    'heic' || 'heif' => MediaType('image', 'heic'),
    'webp' => MediaType('image', 'webp'),
    _ => MediaType('image', 'jpeg'),
  };
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.isOffline = false, this.cause});

  final String message;
  final int? statusCode;

  /// True when we could not reach the server at all, as opposed to the server
  /// telling us no. The caller queues instead of showing an error.
  final bool isOffline;
  final Object? cause;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Kept out of the client so File does not leak into web builds.
Future<int> fileSize(String path) => File(path).length();
