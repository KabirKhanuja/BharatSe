import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/features/add_product/add_product_screen.dart';
import 'package:bharatse/theme/app_theme.dart';
import 'package:bharatse/widgets/offline.dart';

/// The screen is a long scroll. The default 800x600 test surface only builds
/// its top third, so every test mounts it on a tall viewport instead of
/// scrolling to each assertion.
Future<void> _mount(
  WidgetTester tester, {
  LinkState link = LinkState.online,
  int queued = 0,
}) async {
  tester.view.physicalSize = const Size(430, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light,
    home: AddProductScreen(link: link, queued: queued),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the blocks the demo depends on', (tester) async {
    await _mount(tester);

    expect(find.text('दबाकर अपने सामान के बारे में बताइए'), findsOneWidget);
    expect(find.text('बाज़ार में भेजें'), findsOneWidget);
    expect(find.text('सामान की कहानी'), findsOneWidget);
    expect(find.textContaining('सबसे कम', findRichText: true), findsOneWidget);
  });

  testWidgets('every content block can be played aloud', (tester) async {
    await _mount(tester);

    // Story, price and details each carry a speaker. A user who cannot read
    // must be able to hear anything the AI wrote for her.
    expect(find.byIcon(Icons.volume_up_rounded), findsNWidgets(3));
  });

  testWidgets('offline changes the publish affordance and says so', (tester) async {
    await _mount(tester, link: LinkState.offline, queued: 1);

    expect(find.text('फ़ोन में सुरक्षित करें'), findsOneWidget);
    expect(find.text('बाज़ार में भेजें'), findsNothing);
    expect(find.textContaining('इंटरनेट नहीं है'), findsOneWidget);
    expect(find.textContaining('1 चीज़ें'), findsOneWidget);
  });

  testWidgets('online with nothing queued shows no connection strip',
      (tester) async {
    await _mount(tester);
    expect(find.byType(ConnectionStrip), findsOneWidget);
    expect(find.textContaining('सिंक'), findsNothing);
    expect(find.textContaining('इंटरनेट नहीं है'), findsNothing);
  });

  testWidgets('raising hours never leaves the price below the wage floor',
      (tester) async {
    await _mount(tester);

    expect(find.text('₹1,250'), findsOneWidget);

    // 7 hours -> 27 hours. Floor becomes 380 + 27*60 = 2000, which overtakes
    // the 1250 asking price, so the price must be lifted to meet it.
    final plus = find.byKey(const Key('hours-plus'));
    for (var i = 0; i < 20; i++) {
      await tester.tap(plus);
      await tester.pump();
    }

    expect(find.text('27 घंटे'), findsOneWidget);
    expect(find.text('₹2,000'), findsOneWidget);
    expect(find.text('₹1,250'), findsNothing);
  });

  testWidgets('lowering hours does not claw the price back down', (tester) async {
    await _mount(tester);

    final plus = find.byKey(const Key('hours-plus'));
    for (var i = 0; i < 20; i++) {
      await tester.tap(plus);
      await tester.pump();
    }
    final minus = find.byKey(const Key('hours-minus'));
    for (var i = 0; i < 10; i++) {
      await tester.tap(minus);
      await tester.pump();
    }

    // Floor drops to 380 + 17*60 = 1400, but the price she was shown stays.
    expect(find.text('₹2,000'), findsOneWidget);
  });
}
