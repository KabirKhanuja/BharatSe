import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/widgets/craft_image.dart';
import 'package:bharatse/widgets/product_thumb.dart';

/// Picking the wrong image widget fails at runtime inside build, not at compile
/// time, so the choice is pinned here.
Future<void> _pump(WidgetTester tester, String? source) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 80,
          height: 80,
          child: ProductThumb(source: source),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('a stored url renders as a network image', (tester) async {
    await _pump(tester, 'https://x.supabase.co/storage/v1/object/public/a.png');

    expect(find.byType(Image), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
  });

  testWidgets('a phone path renders as a file image', (tester) async {
    await _pump(tester, '/tmp/definitely-not-here.jpg');

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<FileImage>());
  });

  testWidgets('nothing at all falls back to the placeholder', (tester) async {
    await _pump(tester, null);

    expect(find.byType(CraftImage), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('an empty string is treated as nothing, not as a path',
      (tester) async {
    await _pump(tester, '');
    expect(find.byType(CraftImage), findsOneWidget);
  });
}
