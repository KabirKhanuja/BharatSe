import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/data/local/outbox_db.dart' show OutboxDb;
import 'package:bharatse/data/local/product_store.dart';

LocalProduct _product(String clientId, String? owner) => LocalProduct(
      clientId: clientId,
      createdAt: DateTime.now(),
      synced: false,
      ownerId: owner,
      titleEn: 'Listing $clientId',
    );

void main() {
  late OutboxDb db;
  late ProductStore store;

  setUp(() {
    db = OutboxDb.forTesting(NativeDatabase.memory());
    store = DriftProductStore(db);
  });

  tearDown(() => db.close());

  // Two artisans sharing one handset is normal, not an edge case. Before the
  // owner column, the second account to sign in saw the first one's catalogue
  // and could not tell it was not theirs.
  test('one artisan never sees another artisan on the same phone', () async {
    await store.save(_product('kabir-1', 'user-kabir'));
    await store.save(_product('lava-1', 'user-lava'));

    final kabir = await store.all(ownerId: 'user-kabir');
    final lava = await store.all(ownerId: 'user-lava');

    expect(kabir.map((p) => p.clientId), ['kabir-1']);
    expect(lava.map((p) => p.clientId), ['lava-1']);
  });

  // Failing open here would put someone else's listings on screen, so an
  // unknown owner returns nothing rather than everything.
  test('no signed in user returns nothing, not the whole table', () async {
    await store.save(_product('kabir-1', 'user-kabir'));

    expect(await store.all(ownerId: null), isEmpty);
    expect(await store.count(ownerId: null), 0);
  });

  test('rows written before owners existed belong to nobody', () async {
    await store.save(_product('legacy-1', null));

    expect(await store.all(ownerId: 'user-kabir'), isEmpty);
    expect(await store.all(ownerId: null), isEmpty);
  });

  test('a signed in artisan can claim rows the server says are theirs',
      () async {
    await store.save(_product('legacy-1', null));

    await store.adopt(['legacy-1'], 'user-kabir');

    final owned = await store.all(ownerId: 'user-kabir');
    expect(owned.map((p) => p.clientId), ['legacy-1']);
  });

  test('photographs restored from the server survive a reopen', () async {
    await store.save(LocalProduct(
      clientId: 'restored-1',
      createdAt: DateTime.now(),
      synced: true,
      ownerId: 'user-kabir',
      remoteImageUrls: const ['https://example.test/a.jpg'],
    ));

    final rows = await store.all(ownerId: 'user-kabir');
    expect(rows.single.remoteImageUrls, ['https://example.test/a.jpg']);
  });
}
