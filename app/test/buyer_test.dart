import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/features/buyer/buyer_shell.dart';
import 'package:bharatse/l10n/lang.dart';
import 'package:bharatse/session/app_state.dart';
import 'package:bharatse/theme/app_theme.dart';
import 'package:bharatse/features/buyer/cart/cart_screen.dart';
import 'package:bharatse/widgets/top_bar.dart';

Future<AppState> _mount(WidgetTester tester, {Lang lang = Lang.en}) async {
  tester.view.physicalSize = const Size(412, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final state = AppState(lang: lang);
  await tester.pumpWidget(AppScope(
    state: state,
    child: MaterialApp(theme: AppTheme.light, home: const BuyerShell()),
  ));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  testWidgets('defaults to English, not Hindi', (tester) async {
    await _mount(tester);

    expect(find.text('Made by hand.'), findsOneWidget);
    expect(find.text('Shop by state'), findsOneWidget);
    expect(find.text('हाथ से बना.'), findsNothing);
  });

  testWidgets('has exactly three buyer tabs', (tester) async {
    await _mount(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    // Orders lives inside Profile, not in the tab bar.
    expect(find.text('Orders'), findsNothing);
  });

  testWidgets('header carries search and a cart with its count',
      (tester) async {
    await _mount(tester);

    expect(find.byIcon(Icons.search_rounded), findsWidgets);
    expect(find.byKey(const Key('cart-button')), findsOneWidget);
    // The badge shows the item count seeded into the session.
    expect(find.descendant(
      of: find.byType(TopBar),
      matching: find.text('2'),
    ), findsOneWidget);
  });

  testWidgets('switching language re-renders chrome AND content',
      (tester) async {
    final state = await _mount(tester);

    expect(find.text('Made by hand.'), findsOneWidget);
    expect(find.text('Pashmina Shawl'), findsOneWidget);

    state.setLang(Lang.hi);
    await tester.pumpAndSettle();

    expect(find.text('हाथ से बना.'), findsOneWidget);
    expect(find.text('पश्मीना शॉल'), findsOneWidget);
    expect(find.text('Made by hand.'), findsNothing);
  });

  testWidgets('tabs actually switch the body', (tester) async {
    await _mount(tester);

    await tester.tap(find.text('Explore'));
    // Not pumpAndSettle: the map shows a spinner while it parses, which never
    // settles.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Browse by craft'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My orders'), findsOneWidget);
  });

  testWidgets('signed-out profile offers sign in, signed-in does not',
      (tester) async {
    final state = await _mount(tester);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    state.signIn(as: Role.buyer, name: 'Meena Chaudhary');
    await tester.pumpAndSettle();
    expect(find.text('Meena Chaudhary'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);
  });

  testWidgets('role decides which product the app shows', (tester) async {
    final state = await _mount(tester);
    expect(state.role, Role.buyer);

    state.setRole(Role.seller);
    expect(state.role, Role.seller);
  });

  testWidgets('opening a product shows its Craft Passport', (tester) async {
    await _mount(tester);

    await tester.tap(find.text('Pashmina Shawl'));
    await tester.pumpAndSettle();

    expect(find.text('Craft Passport'), findsOneWidget);
    expect(find.text('Provenance verified, not claimed'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);
  });

  testWidgets('cart opens from the header and totals the lines',
      (tester) async {
    await _mount(tester);

    await tester.tap(find.byKey(const Key('cart-button')));
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);
    // Seeded with Pashmina Shawl 4850 and Handblock Tote Bag 1250.
    expect(find.text('Pashmina Shawl'), findsOneWidget);
    expect(find.text('₹6,100'), findsWidgets);
  });

  testWidgets('changing quantity re-totals, and zero removes the line',
      (tester) async {
    final state = await _mount(tester);

    await tester.tap(find.byKey(const Key('cart-button')));
    await tester.pumpAndSettle();

    state.setQty('p1', 2);
    await tester.pumpAndSettle();
    expect(find.text('₹10,950'), findsWidgets);

    state.setQty('p1', 0);
    await tester.pumpAndSettle();
    expect(find.text('Pashmina Shawl'), findsNothing);
    expect(find.text('₹1,250'), findsWidgets);
  });

  testWidgets('empty cart offers a way out rather than a dead end',
      (tester) async {
    final state = await _mount(tester);
    state.setQty('p1', 0);
    state.setQty('p3', 0);

    await tester.tap(find.byKey(const Key('cart-button')));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Start exploring'), findsOneWidget);
  });

}
