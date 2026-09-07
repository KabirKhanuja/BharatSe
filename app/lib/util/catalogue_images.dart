/// How a product's images are ordered and identified once they are saved.
///
/// The enhanced image is a Supabase URL and the artisan's own photos are local
/// file paths. They share one list because `LocalProducts.imagePaths` is
/// already a delimited string column, so carrying the URL there needs no schema
/// change and no Drift migration.
library;

/// True when this entry is a URL rather than a path on the phone.
bool isRemoteImage(String value) =>
    value.startsWith('http://') || value.startsWith('https://');

/// Best image first.
///
/// The catalogue and every consumer that reads only the first entry should get
/// the enhanced image when there is one, and the artisan's own photo when there
/// is not. Originals are kept after it rather than replaced, because the
/// before and after is a feature and a buyer disputing what they saw should be
/// answerable from the original.
List<String> catalogueImages({
  String? heroUrl,
  required List<String> originals,
}) {
  if (heroUrl == null || heroUrl.isEmpty) return List.of(originals);
  if (originals.contains(heroUrl)) return List.of(originals);
  return [heroUrl, ...originals];
}
