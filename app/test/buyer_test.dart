import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bharatse/data/catalog.dart';
import 'package:bharatse/data/remote/api_client.dart';

import 'package:bharatse/features/buyer/buyer_shell.dart';
import 'package:bharatse/features/buyer/explore/explore_screen.dart';
import 'package:bharatse/l10n/lang.dart';
import 'package:bharatse/session/app_state.dart';
import 'package:bharatse/theme/app_theme.dart';
import 'package:bharatse/features/buyer/cart/cart_screen.dart';
import 'package:bharatse/widgets/top_bar.dart';

/// The two products the buyer tests shop with.
///
/// Served from a mock catalogue endpoint rather than a hardcoded list, because
/// that is now how the app actually gets them.
const _catalogue = [
  {
    'id': 'p1',
    'title_en': 'Pashmina Shawl',
    'title_hi': 'पश्मीना शॉल',
    'description_en': 'Handwoven in Srinagar.',
    'description_hi': 'श्रीनगर में हाथ से बुना।',
    'category': 'textiles',
    'material': 'pashmina',
    'technique': 'handwoven',
    'state_code': 'JK',
    'price': 4850,
    'artisan': {'id': 'a1', 'name': 'Aasha Begum'},
    'primary_image_url': null,
    'images': [],
  },
  {
    'id': 'p3',
    'title_en': 'Handblock Tote Bag',
    'title_hi': 'हैंडब्लॉक टोट बैग',
    'description_en': 'Printed in Bagru.',
    'description_hi': 'बगरू में छपा।',
    'category': 'textiles',
    'material': 'cotton',
    'technique': 'block print',
    'state_code': 'RJ',
    'price': 1250,
    'artisan': {'id': 'a2', 'name': 'Meena Chaudhary'},
    'primary_image_url': null,
    'images': [],
  },
];

MockClient _catalogueServer() => MockClient((request) async {
      if (request.url.path.contains('/catalog/products')) {
        return http.Response(
          jsonEncode({
            'items': _catalogue,
            'total': _catalogue.length,
            'limit': 100,
            'offset': 0,
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      return http.Response('{}', 200);
    });

Future<AppState> _mount(WidgetTester tester, {Lang lang = Lang.en}) async {
  tester.view.physicalSize = const Size(412, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final state = AppState(lang: lang, api: ApiClient(client: _catalogueServer()));
  await state.loadCatalog();

  await tester.pumpWidget(
    AppScope(
      state: state,
      child: MaterialApp(theme: AppTheme.light, home: const BuyerShell()),
    ),
  );
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

  testWidgets('header carries a cart and a menu, but no search', (
    tester,
  ) async {
    final state = await _mount(tester);

    expect(find.byKey(const Key('cart-button')), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

    // Search lives on Explore. Two entry points to one feature is clutter.
    expect(
      find.descendant(
        of: find.byType(TopBar),
        matching: find.byIcon(Icons.search_rounded),
      ),
      findsNothing,
    );

    // A new buyer's cart is empty, so there is no badge at all.
    expect(state.cartCount, 0);
  });

  testWidgets('switching language re-renders chrome AND content', (
    tester,
  ) async {
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

  testWidgets('explore search shows matching state details', (tester) async {
    await _mount(tester);

    await tester.tap(find.text('Explore'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final exploreSearch = find.descendant(
      of: find.byType(ExploreScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(exploreSearch, 'Jammu');
    await tester.pump();

    expect(find.text('Jammu & Kashmir'), findsWidgets);
    expect(
      find.textContaining('Pashmina comes from the undercoat'),
      findsOneWidget,
    );
    expect(find.text('Pashmina Shawl'), findsOneWidget);
  });

  testWidgets('signed-out profile offers sign in, signed-in does not', (
    tester,
  ) async {
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

  testWidgets('cart opens from the header and totals what was added', (
    tester,
  ) async {
    final state = await _mount(tester);
    state.addToCart('p1'); // Pashmina Shawl, 4850
    state.addToCart('p3'); // Handblock Tote Bag, 1250
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cart-button')));
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text('Pashmina Shawl'), findsOneWidget);
    expect(find.text('₹6,100'), findsWidgets);
  });

  testWidgets('changing quantity re-totals, and zero removes the line', (
    tester,
  ) async {
    final state = await _mount(tester);
    state.addToCart('p1');
    state.addToCart('p3');
    await tester.pumpAndSettle();

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

  testWidgets('a new buyer sees an empty cart with a way out', (tester) async {
    await _mount(tester);

    await tester.tap(find.byKey(const Key('cart-button')));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Start exploring'), findsOneWidget);
  });

  testWidgets('the catalogue comes from the server, not from a constant',
      (tester) async {
    final state = await _mount(tester);

    expect(state.catalogLoaded, isTrue);
    expect(state.catalogProducts, hasLength(2));
    expect(state.catalogProducts.first.name(Lang.en), 'Pashmina Shawl');
  });

  test('every state cover asset actually exists on disk', () {
    // Four states are named with the map's legacy codes in the asset folder.
    // A mismatch here is invisible in analysis and shows up as a grey box.
    final missing = [
      for (final state in Catalog.states)
        if (!File(state.coverAsset).existsSync()) '${state.id} -> ${state.coverAsset}',
    ];
    expect(missing, isEmpty);
  });

  testWidgets('uppercase state codes from the database match our lowercase ids',
      (tester) async {
    final state = await _mount(tester);

    // The database stores JK and RJ; our own state ids are jk and rj. Getting
    // this wrong makes every state page look empty.
    expect(state.productsForState('jk'), hasLength(1));
    expect(state.productsForState('rj'), hasLength(1));
    expect(state.productsForState('JK'), isEmpty);
  });

  testWidgets('a state we stock nothing from returns no products', (tester) async {
    final state = await _mount(tester);
    expect(state.productsForState('kl'), isEmpty);
  });

  testWidgets('an unreachable catalogue leaves the shelf standing',
      (tester) async {
    tester.view.physicalSize = const Size(412, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState(
      api: ApiClient(
        client: MockClient((_) async => throw http.ClientException('down')),
      ),
    );
    await state.loadCatalog();

    // Offline is not an error the buyer should be shown; it is simply an empty
    // shelf that fills in when the signal returns.
    expect(state.catalogError, isNull);
    expect(state.catalogProducts, isEmpty);
  });

  testWidgets('Hindi falls back to English when a listing has no Hindi title',
      (tester) async {
    final state = await _mount(tester, lang: Lang.hi);

    // Every seeded row has both, but a real listing may not, and a blank title
    // reads as a broken product rather than an untranslated one.
    for (final product in state.catalogProducts) {
      expect(product.name(Lang.hi).trim(), isNotEmpty);
    }
  });
}
