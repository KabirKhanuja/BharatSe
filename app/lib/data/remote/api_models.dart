/// Mirrors of the response shapes in the API repo, `app/schemas/`.
///
/// Kept in one file on purpose. When a field changes on the server, this is
/// the only place in the app that has to change, so a contract drift is one
/// diff and not a hunt. The server serves the whole contract at
/// `/api/v1/openapi.json` if you need to check it.
library;

class AuthToken {
  const AuthToken({
    required this.accessToken,
    required this.role,
    required this.userId,
    required this.name,
  });

  final String accessToken;
  final String role;
  final String userId;
  final String name;

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        accessToken: json['access_token'] as String,
        role: json['role'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String? ?? '',
      );
}

/// What one call returns from the artisan's voice note. Both languages come
/// out of the same pass on the server, so neither is a translation of the
/// other.
class GeneratedListing {
  const GeneratedListing({
    required this.titleEn,
    required this.titleHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.tags,
    required this.materials,
    required this.technique,
    required this.category,
    this.estimatedHours,
    this.transcript = '',
    this.detectedLanguage = '',
  });

  final String titleEn;
  final String titleHi;
  final String descriptionEn;
  final String descriptionHi;
  final List<String> tags;
  final List<String> materials;
  final String technique;
  final String category;
  final double? estimatedHours;
  final String transcript;
  final String detectedLanguage;

  factory GeneratedListing.fromJson(Map<String, dynamic> json) => GeneratedListing(
        titleEn: json['title_en'] as String? ?? '',
        titleHi: json['title_hi'] as String? ?? '',
        descriptionEn: json['description_en'] as String? ?? '',
        descriptionHi: json['description_hi'] as String? ?? '',
        tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        materials:
            (json['materials'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        technique: json['technique'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        estimatedHours: (json['estimated_hours'] as num?)?.toDouble(),
        transcript: json['transcript'] as String? ?? '',
        detectedLanguage: json['detected_language'] as String? ?? '',
      );
}

class ListingResult {
  const ListingResult({required this.listing, required this.provider});

  final GeneratedListing listing;
  final String provider;

  factory ListingResult.fromJson(Map<String, dynamic> json) => ListingResult(
        listing: GeneratedListing.fromJson(json['listing'] as Map<String, dynamic>),
        provider: json['provider'] as String? ?? 'unknown',
      );
}

/// The arithmetic behind the floor, so the app can show its working rather
/// than asserting a number.
class FloorBreakdown {
  const FloorBreakdown({
    required this.materialCost,
    required this.labourCost,
    required this.overhead,
    required this.floor,
    required this.wagePerHour,
    required this.hours,
  });

  final int materialCost;
  final int labourCost;
  final int overhead;
  final int floor;
  final int wagePerHour;
  final double hours;

  factory FloorBreakdown.fromJson(Map<String, dynamic> json) => FloorBreakdown(
        materialCost: (json['material_cost'] as num).toInt(),
        labourCost: (json['labour_cost'] as num).toInt(),
        overhead: (json['overhead'] as num).toInt(),
        floor: (json['floor'] as num).toInt(),
        wagePerHour: (json['wage_per_hour'] as num).toInt(),
        hours: (json['hours'] as num).toDouble(),
      );
}

class PriceBand {
  const PriceBand({
    required this.p10,
    required this.p50,
    required this.p90,
    required this.floor,
    required this.breakdown,
    required this.modelUsed,
    required this.liftedToFloor,
    required this.note,
  });

  final int p10;
  final int p50;
  final int p90;
  final int floor;
  final FloorBreakdown breakdown;
  final bool modelUsed;

  /// True when the market band came out below the floor and was raised to meet
  /// it. Worth surfacing, because it is the guarantee actually firing.
  final bool liftedToFloor;
  final String note;

  factory PriceBand.fromJson(Map<String, dynamic> json) => PriceBand(
        p10: (json['p10'] as num).toInt(),
        p50: (json['p50'] as num).toInt(),
        p90: (json['p90'] as num).toInt(),
        floor: (json['floor'] as num).toInt(),
        breakdown:
            FloorBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
        modelUsed: json['model_used'] as bool? ?? false,
        liftedToFloor: json['lifted_to_floor'] as bool? ?? false,
        note: json['note'] as String? ?? '',
      );
}

class RemoteProduct {
  const RemoteProduct({
    required this.id,
    required this.clientId,
    required this.status,
    this.titleEn,
    this.titleHi,
    this.price,
    this.priceFloor,
  });

  final String id;
  final String clientId;
  final String status;
  final String? titleEn;
  final String? titleHi;
  final int? price;
  final int? priceFloor;

  factory RemoteProduct.fromJson(Map<String, dynamic> json) => RemoteProduct(
        id: json['id'] as String,
        clientId: json['client_id'] as String,
        status: json['status'] as String? ?? 'draft',
        titleEn: json['title_en'] as String?,
        titleHi: json['title_hi'] as String?,
        price: (json['price'] as num?)?.toInt(),
        priceFloor: (json['price_floor'] as num?)?.toInt(),
      );
}

class SyncResult {
  const SyncResult({
    required this.accepted,
    required this.created,
    required this.updated,
    required this.ids,
  });

  final int accepted;
  final int created;
  final int updated;

  /// client_id to server id, so the phone can record what landed.
  final Map<String, String> ids;

  factory SyncResult.fromJson(Map<String, dynamic> json) => SyncResult(
        accepted: (json['accepted'] as num).toInt(),
        created: (json['created'] as num).toInt(),
        updated: (json['updated'] as num).toInt(),
        ids: (json['ids'] as Map?)?.map((k, v) => MapEntry('$k', '$v')) ?? const {},
      );
}

class PassportIssue {
  const PassportIssue({
    required this.productId,
    required this.qrContent,
    required this.payloadB64,
    required this.signatureB64,
    required this.publicKeyHex,
  });

  final String productId;

  /// Exactly what goes in the QR: the signed bytes and the signature. The
  /// payload is never re-serialised on this side to verify it, because Dart
  /// and Python encode JSON differently and a re-encoded payload will not
  /// match the signature.
  final String qrContent;
  final String payloadB64;
  final String signatureB64;
  final String publicKeyHex;

  factory PassportIssue.fromJson(Map<String, dynamic> json) => PassportIssue(
        productId: json['product_id'] as String,
        qrContent: json['qr_content'] as String,
        payloadB64: json['payload_b64'] as String,
        signatureB64: json['signature_b64'] as String,
        publicKeyHex: json['public_key_hex'] as String? ?? '',
      );
}

/// One stored photo of a product, as the server keeps it.
class ListingImage {
  const ListingImage({
    required this.position,
    required this.originalUrl,
    this.enhancedUrl,
    this.isHero = false,
  });

  final int position;
  final String originalUrl;

  /// Set on the hero only. Every other photo is stored as the artisan took it.
  final String? enhancedUrl;
  final bool isHero;

  factory ListingImage.fromJson(Map<String, dynamic> json) => ListingImage(
        position: (json['position'] as num?)?.toInt() ?? 0,
        originalUrl: json['original_url'] as String? ?? '',
        enhancedUrl: json['enhanced_url'] as String?,
        isHero: json['is_hero'] as bool? ?? false,
      );
}

/// The result of preparing one product's photos.
///
/// `enhancedCount` is 0 or 1. Image generation is the only call in this app
/// billed per invocation, and the ceiling is enforced by the server rather than
/// trusted to the phone.
class ListingImages {
  const ListingImages({
    required this.productId,
    required this.clientId,
    required this.images,
    required this.heroUrl,
    required this.method,
    required this.enhancedCount,
  });

  final String productId;
  final String clientId;
  final List<ListingImage> images;

  /// What the listing shows. The enhanced image when there is one, and the
  /// artisan's own photo when the model was unreachable, so a listing is never
  /// imageless because an API was down.
  final String heroUrl;

  /// "generative", "cutout" or "none". Worth surfacing: an artisan should know
  /// whether she is looking at the good pass or the offline one.
  final String method;
  final int enhancedCount;

  bool get wasEnhanced => enhancedCount > 0;

  ListingImage? get hero {
    for (final image in images) {
      if (image.isHero) return image;
    }
    return images.isEmpty ? null : images.first;
  }

  factory ListingImages.fromJson(Map<String, dynamic> json) => ListingImages(
        productId: json['product_id'] as String? ?? '',
        clientId: json['client_id'] as String? ?? '',
        images: (json['images'] as List?)
                ?.map((e) => ListingImage.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        heroUrl: json['hero_url'] as String? ?? '',
        method: json['method'] as String? ?? 'none',
        enhancedCount: (json['enhanced_count'] as num?)?.toInt() ?? 0,
      );
}
