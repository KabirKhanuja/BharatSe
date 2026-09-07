import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'outbox_db.dart';

/// A thing that happened on the phone and has not reached the server yet.
class PendingItem {
  const PendingItem({
    required this.clientId,
    required this.entity,
    required this.op,
    required this.payload,
    required this.attempts,
    this.lastError,
  });

  final String clientId;
  final String entity;
  final String op;
  final Map<String, dynamic> payload;
  final int attempts;
  final String? lastError;
}

/// Storage for the outbox.
///
/// Behind an interface because Drift needs a real sqlite, which web builds do
/// not have without shipping a wasm bundle. On web we keep the queue in memory
/// so previews still work; on a phone, which is the only place that matters
/// for this feature, it is durable.
abstract class OutboxStore {
  Future<void> enqueue(PendingItem item);
  Future<List<PendingItem>> pending({int limit = 50});
  Future<int> pendingCount();
  Future<void> markSent(String clientId);
  Future<void> markFailed(String clientId, String error);
  Future<void> clear();
}

class DriftOutboxStore implements OutboxStore {
  DriftOutboxStore(this._db);
  final OutboxDb _db;

  @override
  Future<void> enqueue(PendingItem item) async {
    // Upsert, not insert. Editing a draft twice while offline should leave one
    // queued row carrying the latest state, not two rows racing each other.
    await _db.into(_db.outboxEntries).insertOnConflictUpdate(
          OutboxEntriesCompanion.insert(
            clientId: item.clientId,
            entity: item.entity,
            op: item.op,
            payload: jsonEncode(item.payload),
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<PendingItem>> pending({int limit = 50}) async {
    final query = _db.select(_db.outboxEntries)
      ..where((t) => t.sent.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(limit);

    return (await query.get())
        .map((row) => PendingItem(
              clientId: row.clientId,
              entity: row.entity,
              op: row.op,
              payload: jsonDecode(row.payload) as Map<String, dynamic>,
              attempts: row.attempts,
              lastError: row.lastError,
            ))
        .toList();
  }

  @override
  Future<int> pendingCount() async {
    final count = _db.outboxEntries.clientId.count();
    final query = _db.selectOnly(_db.outboxEntries)
      ..addColumns([count])
      ..where(_db.outboxEntries.sent.equals(false));
    return (await query.getSingle()).read(count) ?? 0;
  }

  @override
  Future<void> markSent(String clientId) async {
    await (_db.update(_db.outboxEntries)
          ..where((t) => t.clientId.equals(clientId)))
        .write(const OutboxEntriesCompanion(sent: Value(true)));
  }

  @override
  Future<void> markFailed(String clientId, String error) async {
    final row = await (_db.select(_db.outboxEntries)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();

    await (_db.update(_db.outboxEntries)
          ..where((t) => t.clientId.equals(clientId)))
        .write(OutboxEntriesCompanion(
      attempts: Value((row?.attempts ?? 0) + 1),
      lastError: Value(error),
    ));
  }

  @override
  Future<void> clear() => _db.delete(_db.outboxEntries).go();
}

/// Used on web, and as a fallback if opening the database fails. Losing the
/// queue is better than failing to start.
class MemoryOutboxStore implements OutboxStore {
  final Map<String, PendingItem> _items = {};

  @override
  Future<void> enqueue(PendingItem item) async => _items[item.clientId] = item;

  @override
  Future<List<PendingItem>> pending({int limit = 50}) async =>
      _items.values.take(limit).toList();

  @override
  Future<int> pendingCount() async => _items.length;

  @override
  Future<void> markSent(String clientId) async => _items.remove(clientId);

  @override
  Future<void> markFailed(String clientId, String error) async {
    final existing = _items[clientId];
    if (existing == null) return;
    _items[clientId] = PendingItem(
      clientId: existing.clientId,
      entity: existing.entity,
      op: existing.op,
      payload: existing.payload,
      attempts: existing.attempts + 1,
      lastError: error,
    );
  }

  @override
  Future<void> clear() async => _items.clear();
}

Future<OutboxStore> openOutboxStore() async {
  if (kIsWeb) return MemoryOutboxStore();
  try {
    return DriftOutboxStore(OutboxDb());
  } catch (error) {
    debugPrint('Outbox database unavailable, falling back to memory: $error');
    return MemoryOutboxStore();
  }
}
