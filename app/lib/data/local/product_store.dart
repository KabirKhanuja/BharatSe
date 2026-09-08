import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'outbox_db.dart';

/// A product as the phone knows it.
///
/// The phone is the source of truth until the server has seen it. That is what
/// lets an artisan open her catalogue on a bus with no signal and still see
/// everything she has made today.
class LocalProduct {
  const LocalProduct({
    required this.clientId,
    required this.createdAt,
    required this.synced,
    this.ownerId,
    this.serverId,
    this.titleEn,
    this.titleHi,
    this.descriptionEn,
    this.descriptionHi,
    this.category,
    this.material,
    this.technique,
    this.hoursOfWork,
    this.materialCost,
    this.priceFloor,
    this.price,
    this.imagePaths = const [],
    this.remoteImageUrls = const [],
  });

  final String clientId;
  final DateTime createdAt;
  final bool synced;

  /// The signed in account that made this listing. Two artisans can share one
  /// phone, and without this every account sees every product on the device.
  final String? ownerId;
  final String? serverId;
  final List<String> remoteImageUrls;
  final String? titleEn;
  final String? titleHi;
  final String? descriptionEn;
  final String? descriptionHi;
  final String? category;
  final String? material;
  final String? technique;
  final double? hoursOfWork;
  final int? materialCost;
  final int? priceFloor;
  final int? price;
  final List<String> imagePaths;

  String title(String lang) =>
      (lang == 'hi' ? titleHi : titleEn) ?? titleEn ?? titleHi ?? '';

  LocalProduct withOwner(String owner) => LocalProduct(
        clientId: clientId,
        createdAt: createdAt,
        synced: synced,
        ownerId: owner,
        serverId: serverId,
        titleEn: titleEn,
        titleHi: titleHi,
        descriptionEn: descriptionEn,
        descriptionHi: descriptionHi,
        category: category,
        material: material,
        technique: technique,
        hoursOfWork: hoursOfWork,
        materialCost: materialCost,
        priceFloor: priceFloor,
        price: price,
        imagePaths: imagePaths,
        remoteImageUrls: remoteImageUrls,
      );
}

abstract class ProductStore {
  Future<void> save(LocalProduct product);

  /// Only what [ownerId] made. A null owner returns nothing rather than
  /// everything, because the failure of a scoped query should be an empty
  /// screen and never another person's catalogue.
  Future<List<LocalProduct>> all({String? ownerId});
  Future<void> markSynced(String clientId, String serverId);
  Future<int> count({String? ownerId});

  /// Claim rows this account has already synced to the server.
  ///
  /// Rows written before owners existed, and rows restored from the server
  /// after a reinstall, both need an owner attached once we know who is
  /// signed in and that the server agrees the listing is theirs.
  Future<void> adopt(Iterable<String> clientIds, String ownerId);
}

class DriftProductStore implements ProductStore {
  DriftProductStore(this._db);
  final OutboxDb _db;

  @override
  Future<void> save(LocalProduct p) async {
    await _db.into(_db.localProducts).insertOnConflictUpdate(
          LocalProductsCompanion.insert(
            clientId: p.clientId,
            createdAt: p.createdAt,
            ownerId: Value(p.ownerId),
            serverId: Value(p.serverId),
            titleEn: Value(p.titleEn),
            titleHi: Value(p.titleHi),
            descriptionEn: Value(p.descriptionEn),
            descriptionHi: Value(p.descriptionHi),
            category: Value(p.category),
            material: Value(p.material),
            technique: Value(p.technique),
            hoursOfWork: Value(p.hoursOfWork),
            materialCost: Value(p.materialCost),
            priceFloor: Value(p.priceFloor),
            price: Value(p.price),
            imagePaths: Value(p.imagePaths.join('|')),
            remoteImageUrls: Value(p.remoteImageUrls.join('|')),
            synced: Value(p.synced),
          ),
        );
  }

  @override
  Future<List<LocalProduct>> all({String? ownerId}) async {
    if (ownerId == null) return const [];

    final query = _db.select(_db.localProducts)
      ..where((t) => t.ownerId.equals(ownerId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    return (await query.get())
        .map((r) => LocalProduct(
              clientId: r.clientId,
              createdAt: r.createdAt,
              synced: r.synced,
              ownerId: r.ownerId,
              serverId: r.serverId,
              titleEn: r.titleEn,
              titleHi: r.titleHi,
              descriptionEn: r.descriptionEn,
              descriptionHi: r.descriptionHi,
              category: r.category,
              material: r.material,
              technique: r.technique,
              hoursOfWork: r.hoursOfWork,
              materialCost: r.materialCost,
              priceFloor: r.priceFloor,
              price: r.price,
              imagePaths:
                  r.imagePaths.isEmpty ? const [] : r.imagePaths.split('|'),
              remoteImageUrls: r.remoteImageUrls.isEmpty
                  ? const []
                  : r.remoteImageUrls.split('|'),
            ))
        .toList();
  }

  @override
  Future<void> markSynced(String clientId, String serverId) async {
    await (_db.update(_db.localProducts)
          ..where((t) => t.clientId.equals(clientId)))
        .write(LocalProductsCompanion(
      synced: const Value(true),
      serverId: Value(serverId),
    ));
  }

  @override
  Future<int> count({String? ownerId}) async =>
      (await all(ownerId: ownerId)).length;

  @override
  Future<void> adopt(Iterable<String> clientIds, String ownerId) async {
    if (clientIds.isEmpty) return;
    await (_db.update(_db.localProducts)
          ..where((t) => t.clientId.isIn(clientIds.toList())))
        .write(LocalProductsCompanion(ownerId: Value(ownerId)));
  }
}

class MemoryProductStore implements ProductStore {
  final Map<String, LocalProduct> _items = {};

  @override
  Future<void> save(LocalProduct product) async =>
      _items[product.clientId] = product;

  @override
  Future<List<LocalProduct>> all({String? ownerId}) async {
    if (ownerId == null) return const [];
    final list = _items.values.where((p) => p.ownerId == ownerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> markSynced(String clientId, String serverId) async {
    final existing = _items[clientId];
    if (existing == null) return;
    _items[clientId] = LocalProduct(
      clientId: existing.clientId,
      createdAt: existing.createdAt,
      synced: true,
      serverId: serverId,
      titleEn: existing.titleEn,
      titleHi: existing.titleHi,
      descriptionEn: existing.descriptionEn,
      descriptionHi: existing.descriptionHi,
      category: existing.category,
      material: existing.material,
      technique: existing.technique,
      hoursOfWork: existing.hoursOfWork,
      materialCost: existing.materialCost,
      priceFloor: existing.priceFloor,
      price: existing.price,
      imagePaths: existing.imagePaths,
      remoteImageUrls: existing.remoteImageUrls,
    );
  }

  @override
  Future<int> count({String? ownerId}) async =>
      (await all(ownerId: ownerId)).length;

  @override
  Future<void> adopt(Iterable<String> clientIds, String ownerId) async {
    for (final id in clientIds) {
      final existing = _items[id];
      if (existing == null) continue;
      _items[id] = existing.withOwner(ownerId);
    }
  }
}

ProductStore openProductStore({OutboxDb? db}) {
  if (kIsWeb || db == null) return MemoryProductStore();
  try {
    return DriftProductStore(db);
  } catch (error) {
    debugPrint('Product store unavailable, falling back to memory: $error');
    return MemoryProductStore();
  }
}
