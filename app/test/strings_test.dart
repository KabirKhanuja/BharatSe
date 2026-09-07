import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/l10n/lang.dart';
import 'package:bharatse/l10n/strings.dart';

/// Ten languages are offered in the picker, so ten have to actually resolve.
/// A picker that silently falls back to English is worse than a shorter one.
void main() {
  test('every language in the picker resolves to its own table', () {
    final tables = <Lang, AppStrings>{
      for (final lang in Lang.values) lang: AppStrings.of(lang),
    };

    // Only English should be the English table.
    for (final lang in Lang.values.where((l) => l != Lang.en)) {
      expect(
        identical(tables[lang], AppStrings.en),
        isFalse,
        reason: '${lang.englishName} falls back to English',
      );
    }
  });

  test('no language has an empty label where English has one', () {
    for (final lang in Lang.values) {
      final s = AppStrings.of(lang);
      for (final entry in {
        'navHome': s.navHome,
        'navExplore': s.navExplore,
        'navProfile': s.navProfile,
        'signInAction': s.signInAction,
        'addProduct': s.addProduct,
        'tapToSpeak': s.tapToSpeak,
        'publishToMarket': s.publishToMarket,
        'suggestedPrice': s.suggestedPrice,
      }.entries) {
        expect(
          entry.value.trim(),
          isNotEmpty,
          reason: '${lang.englishName} has an empty ${entry.key}',
        );
      }
    }
  });

  test('the {n} placeholder survives translation', () {
    // These strings interpolate a count. A translation that drops the
    // placeholder produces a sentence with a missing number.
    for (final lang in Lang.values) {
      final s = AppStrings.of(lang);
      expect(s.offlineNoticeWithCount, contains('{n}'),
          reason: '${lang.englishName} lost {n} in offlineNoticeWithCount');
      expect(s.syncing, contains('{n}'),
          reason: '${lang.englishName} lost {n} in syncing');
    }
  });

  test('brand and technical terms are left untranslated', () {
    for (final lang in Lang.values) {
      final s = AppStrings.of(lang);
      expect(s.continueWithGoogle.toLowerCase(), contains('google'),
          reason: '${lang.englishName} translated Google');
    }
  });

  test('every language has a native name distinct from English', () {
    final native = Lang.values.map((l) => l.nativeName).toSet();
    expect(native.length, Lang.values.length, reason: 'duplicate native names');
  });
}
