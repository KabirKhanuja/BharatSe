import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/data/catalog.dart';
import 'package:bharatse/data/techniques.dart';
import 'package:bharatse/l10n/lang.dart';

/// The heritage notes are what turn a marketplace into a heritage marketplace,
/// so they are checked for shape here. Nobody can unit test whether history is
/// true, but they can be stopped from being empty, truncated or unreachable.
void main() {
  test('every technique in the catalogue has a note', () {
    // These are the techniques Postgres actually holds.
    const inCatalogue = [
      'inlay', 'embossing', 'embroidery', 'gond', 'metalwork', 'dhokra',
      'meenakari', 'kalighat', 'kashida', 'bookbinding', 'batik', 'tarakashi',
      'glasswork', 'weaving', 'tribal art', 'cloth folding and tying',
      'blue pottery', 'miniature painting', 'coconut craft', 'handicraft',
    ];

    for (final key in inCatalogue) {
      expect(Techniques.byKey(key), isNotNull, reason: 'no note for $key');
    }
  });

  test('lookup is forgiving about case and padding', () {
    // Postgres holds these however the seeder wrote them.
    expect(Techniques.byKey('Dhokra')?.key, 'dhokra');
    expect(Techniques.byKey('  DHOKRA  ')?.key, 'dhokra');
    expect(Techniques.byKey(null), isNull);
    expect(Techniques.byKey('not a technique'), isNull);
  });

  test('histories are long enough to be worth reading', () {
    for (final technique in Techniques.all) {
      final sentences = technique.history(Lang.en).split('.').where(
            (part) => part.trim().length > 12,
          );
      expect(
        sentences.length,
        greaterThanOrEqualTo(8),
        reason: '${technique.title} has only ${sentences.length} sentences',
      );
    }
  });

  test('both languages are present and neither is a stub', () {
    for (final technique in Techniques.all) {
      expect(technique.history(Lang.en).trim(), isNotEmpty);
      expect(technique.history(Lang.hi).trim(), isNotEmpty);
      expect(technique.history(Lang.hi).length, greaterThan(200),
          reason: '${technique.title} Hindi looks truncated');
    }
  });

  test('each one names where it is practised and why it takes time', () {
    for (final technique in Techniques.all) {
      expect(technique.region.trim(), isNotEmpty, reason: technique.title);
      expect(technique.whyItCosts.trim(), isNotEmpty, reason: technique.title);
      expect(technique.title, isNot(equals(technique.key)),
          reason: '${technique.key} was never given a proper name');
    }
  });

  test('every state code in the catalogue has an entry', () {
    // Codes present in Postgres, lowercased the way the app stores them.
    const codes = [
      'ap', 'ar', 'as', 'br', 'cg', 'ga', 'gj', 'hp', 'hr', 'jh', 'jk', 'ka',
      'mh', 'ml', 'mp', 'mz', 'nl', 'pb', 'rj', 'sk', 'tn', 'tr', 'ts', 'uk',
      'up', 'wb',
    ];

    for (final code in codes) {
      expect(Catalog.hasState(code), isTrue,
          reason: 'no state entry for $code, so its products show under nothing');
    }
  });

  test('no state is left without heritage text', () {
    for (final state in Catalog.states) {
      expect(state.heritage(Lang.en).trim(), isNotEmpty, reason: state.id);
      expect(state.heritage(Lang.hi).trim(), isNotEmpty, reason: state.id);
      expect(state.crafts(Lang.en).trim(), isNotEmpty, reason: state.id);
    }
  });

  test('state ids are unique', () {
    final ids = Catalog.states.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate state id');
  });
}
