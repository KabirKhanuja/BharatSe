import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../data/local/outbox_repository.dart';
import '../data/remote/api_client.dart';
import '../session/link_state.dart';

/// Drains the outbox when a signal appears.
///
/// Two things this deliberately does not do.
///
/// It does not treat connectivity_plus as truth. That plugin reports the
/// connection TYPE, not reachability, and its own docs say so. On rural
/// cellular it will happily report "mobile connected" while every request
/// hangs. So its events are a hint to try, never a gate, and every request has
/// a hard timeout underneath.
///
/// It does not use workmanager. iOS background scheduling is opaque and cannot
/// be triggered on demand, and the plugin has no licence file. Draining on
/// foreground and on connectivity change covers everything a person will
/// actually see.
class SyncService extends ChangeNotifier {
  SyncService({required this.api, required this.outbox, this.ensureSession});

  final ApiClient api;
  final OutboxStore outbox;

  /// Called before a drain so queued work is not sent without a token, which
  /// the server rejects with a 401 and which reads here as a plain failure.
  final Future<bool> Function()? ensureSession;

  LinkState _link = LinkState.online;
  int _pending = 0;
  bool _draining = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;

  LinkState get link => _link;
  int get pending => _pending;

  Future<void> start() async {
    await refreshCount();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final maybeOnline =
          results.any((r) => r != ConnectivityResult.none);
      if (maybeOnline) {
        drain();
      } else {
        _setLink(LinkState.offline);
      }
    });

    unawaited(drain());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> refreshCount() async {
    _pending = await outbox.pendingCount();
    if (_pending == 0 && _link == LinkState.syncing) _link = LinkState.online;
    notifyListeners();
  }

  void _setLink(LinkState next) {
    if (_link == next) return;
    _link = next;
    notifyListeners();
  }

  /// Queue something. Never throws, because losing the artisan's work because
  /// the network was down is the exact failure this whole design exists to
  /// prevent.
  Future<void> enqueue({
    required String clientId,
    required String entity,
    required String op,
    required Map<String, dynamic> payload,
  }) async {
    await outbox.enqueue(PendingItem(
      clientId: clientId,
      entity: entity,
      op: op,
      payload: payload,
      attempts: 0,
    ));
    await refreshCount();
    unawaited(drain());
  }

  /// Send everything queued. Safe to call at any time; overlapping calls are
  /// collapsed.
  Future<void> drain() async {
    if (_draining) return;

    final items = await outbox.pending();
    if (items.isEmpty) {
      _setLink(LinkState.online);
      return;
    }

    _draining = true;
    _setLink(LinkState.syncing);
    notifyListeners();

    try {
      if (ensureSession != null && !api.isAuthenticated) {
        await ensureSession!();
      }
      final products =
          items.where((i) => i.entity == 'product').toList(growable: false);

      if (products.isNotEmpty) {
        // One batched call, and it upserts on client_id server side, so a
        // retry after a dropped connection cannot duplicate rows.
        final result = await api.syncProducts(
          products.map((p) => {...p.payload, 'client_id': p.clientId}).toList(),
        );

        for (final item in products) {
          if (result.ids.containsKey(item.clientId)) {
            await outbox.markSent(item.clientId);
          }
        }
      }

      _setLink(LinkState.online);
      _retryTimer?.cancel();
    } on ApiException catch (error) {
      for (final item in items) {
        await outbox.markFailed(item.clientId, error.message);
      }
      _setLink(error.isOffline ? LinkState.offline : LinkState.online);
      _scheduleRetry();
    } finally {
      _draining = false;
      await refreshCount();
    }
  }

  /// Back off rather than hammering a network that is not there.
  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 20), drain);
  }

  /// Development affordance so the offline story can be rehearsed at a desk.
  void forceLink(LinkState state) {
    _link = state;
    notifyListeners();
  }
}
