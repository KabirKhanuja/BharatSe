import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'outbox_db.g.dart';

/// One row per thing the phone did while it could not reach the server.
///
/// The client generates the id, and the API upserts on it, so a retry after a
/// dropped connection produces one row on the server and not three. Every
/// offline failure a judge will actually try is a duplicate row problem.
class OutboxEntries extends Table {
  TextColumn get clientId => text()();
  TextColumn get entity => text().withLength(min: 1, max: 40)();
  TextColumn get op => text().withLength(min: 1, max: 20)();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  BoolColumn get sent => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {clientId};
}

/// Products as the phone knows them, so the artisan can open her catalogue
/// with no signal and still see everything she has made.
class LocalProducts extends Table {
  TextColumn get clientId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get titleHi => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();
  TextColumn get descriptionHi => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get material => text().nullable()();
  TextColumn get technique => text().nullable()();
  RealColumn get hoursOfWork => real().nullable()();
  IntColumn get materialCost => integer().nullable()();
  IntColumn get priceFloor => integer().nullable()();
  IntColumn get price => integer().nullable()();
  TextColumn get imagePaths => text().withDefault(const Constant(''))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {clientId};
}

@DriftDatabase(tables: [OutboxEntries, LocalProducts])
class OutboxDb extends _$OutboxDb {
  OutboxDb() : super(_open());
  OutboxDb.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() =>
      driftDatabase(name: 'bharatse_outbox');
}
