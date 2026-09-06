/// The languages the interface itself is available in.
///
/// This is separate from the languages an artisan may SPEAK into the app.
/// She can dictate in any Indian language; the chrome around her is
/// translated only where we have reviewed the wording.
enum Lang {
  en('English', 'English'),
  hi('हिन्दी', 'Hindi');

  const Lang(this.nativeName, this.englishName);

  final String nativeName;
  final String englishName;
}

/// A string that exists in both interface languages.
///
/// Used for content (product names, state names) that lives in data rather
/// than in the string table.
class T {
  const T(this.en, this.hi);
  final String en;
  final String hi;

  String call(Lang lang) => lang == Lang.hi ? hi : en;
}
