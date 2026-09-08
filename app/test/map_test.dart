import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_drawing/path_drawing.dart';

import 'package:bharatse/data/catalog.dart';

/// Reads the map asset from disk rather than through rootBundle, which does
/// not resolve inside the widget-test async zone.
void main() {
  late Map<String, dynamic> json;

  setUpAll(() {
    json = jsonDecode(File('assets/map/india_states.json').readAsStringSync())
        as Map<String, dynamic>;
  });

  test('carries every state and union territory', () {
    expect((json['states'] as List).length, 36);
  });

  test('every path parses into real geometry', () {
    for (final s in json['states'] as List) {
      final path = parseSvgPathData(s['d'] as String);
      final b = path.getBounds();
      expect(b.width, greaterThan(0), reason: '${s['id']} has no width');
      expect(b.height, greaterThan(0), reason: '${s['id']} has no height');
    }
  });

  test('includes Jammu and Kashmir with its full northern extent', () {
    final states = json['states'] as List;
    final jk = states.firstWhere((s) => s['id'] == 'jk');
    expect(jk['name'], 'Jammu and Kashmir');

    final vb = (json['viewBox'] as String).split(RegExp(r'\s+'));
    final height = double.parse(vb[3]);
    final bounds = parseSvgPathData(jk['d'] as String).getBounds();

    // It must reach the top of the viewBox. A map that clips the north is not
    // one we can put in front of a ministry panel.
    expect(bounds.top, lessThan(height * 0.05));
  });

  test('every state we stock crafts from exists on the map', () {
    // Must stay in step with _idAliases in india_map.dart. The map file
    // predates the 2019 reorganisation, and each unaliased code is a state
    // nobody can tap.
    const aliases = {'or': 'od', 'ct': 'cg', 'tg': 'ts', 'ut': 'uk'};
    final mapIds = {
      for (final s in json['states'] as List)
        aliases[s['id'] as String] ?? s['id'] as String,
    };

    for (final st in Catalog.states) {
      expect(mapIds, contains(st.id), reason: 'map is missing ${st.id}');
    }
  });

  test('attribution is carried with the data', () {
    // CC BY 4.0 requires it, and it must travel with the file rather than
    // living only in a commit message.
    expect(json['attribution'], contains('CC BY 4.0'));
  });
}
