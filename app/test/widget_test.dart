import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/features/seller/add_product_screen.dart';
import 'package:bharatse/session/app_state.dart';
import 'package:bharatse/data/local/outbox_repository.dart';
import 'package:bharatse/widgets/offline.dart';

/// The listing flow starts empty on purpose. Nothing below the microphone
/// exists until she has actually said something, so these tests assert the
/// empty state and the offline affordances rather than pre filled content.
Future<AppState> _mount(
  WidgetTester tester, {
  LinkState link = LinkState.online,
  int queued = 0,
}) async {
  tester.view.physicalSize = const Size(412, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final state = AppState();

  // Queue real items rather than faking a count, so the strip is exercised
  // through the same path the app uses.
  for (var i = 0; i < queued; i++) {
    await state.sync.outbox.enqueue(PendingItem(
      clientId: 'test-$i',
      entity: 'product',
      op: 'upsert',
      payload: const {},
      attempts: 0,
    ));
  }
  await state.sync.refreshCount();
  state.cycleLinkTo(link);

  await tester.pumpWidget(AppScope(
    state: state,
    child: const MaterialApp(
      home: AddProductScreen(),
    ),
  ));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  testWidgets('opens in English, asking for a photo and a voice note',
      (tester) async {
    await _mount(tester);

    expect(find.text('Add photo or video'), findsOneWidget);
    expect(find.text('Hold and tell us about your product'), findsOneWidget);
    expect(find.text('In your own language'), findsOneWidget);
  });

  testWidgets('shows nothing below the microphone until she has spoken',
      (tester) async {
    await _mount(tester);

    expect(find.text('The story of this piece'), findsNothing);
    expect(find.text('Suggested price'), findsNothing);
    expect(find.text('Details'), findsNothing);
  });

  testWidgets('publish is disabled until there is something to publish',
      (tester) async {
    await _mount(tester);

    final button = tester.widget<FilledButton>(find.byType(FilledButton).last);
    expect(button.onPressed, isNull);
  });

  testWidgets('offline changes the publish wording and says why',
      (tester) async {
    await _mount(tester, link: LinkState.offline, queued: 1);

    expect(find.text('Save on this phone'), findsOneWidget);
    expect(find.text('Send to market'), findsNothing);
    expect(find.textContaining('No internet'), findsOneWidget);
    expect(find.textContaining('1 saved on your phone'), findsOneWidget);
  });

  testWidgets('online with nothing queued shows no connection strip',
      (tester) async {
    await _mount(tester);

    expect(find.byType(ConnectionStrip), findsOneWidget);
    expect(find.textContaining('No internet'), findsNothing);
    expect(find.textContaining('Syncing'), findsNothing);
  });

  testWidgets('the microphone and the photo tile are both reachable',
      (tester) async {
    await _mount(tester);

    expect(find.byKey(const Key('mic')), findsOneWidget);
    expect(find.byKey(const Key('add-photo')), findsOneWidget);
  });
}
