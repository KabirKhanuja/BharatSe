import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/util/catalogue_images.dart';

/// The catalogue reads only the first image, so the ordering here decides
/// whether an artisan sees her improved photo or her raw one after publishing.
void main() {
  group('isRemoteImage', () {
    test('recognises urls', () {
      expect(isRemoteImage('https://x.supabase.co/a.png'), isTrue);
      expect(isRemoteImage('http://x.supabase.co/a.png'), isTrue);
    });

    test('treats phone paths as local', () {
      expect(isRemoteImage('/data/user/0/com.x/cache/note.jpg'), isFalse);
      expect(isRemoteImage('file:///tmp/a.jpg'), isFalse);
      expect(isRemoteImage(''), isFalse);
    });
  });

  group('catalogueImages', () {
    const originals = ['/tmp/a.jpg', '/tmp/b.jpg'];

    test('puts the enhanced image first', () {
      final result = catalogueImages(
        heroUrl: 'https://x.supabase.co/hero.png',
        originals: originals,
      );

      expect(result.first, 'https://x.supabase.co/hero.png');
      expect(result, hasLength(3));
    });

    test('keeps the originals rather than replacing them', () {
      final result = catalogueImages(
        heroUrl: 'https://x.supabase.co/hero.png',
        originals: originals,
      );

      // The before and after is a feature, and a buyer disputing what they saw
      // should be answerable from the original.
      expect(result.sublist(1), originals);
    });

    test('falls back to the artisan photos when nothing was enhanced', () {
      expect(catalogueImages(heroUrl: null, originals: originals), originals);
      expect(catalogueImages(heroUrl: '', originals: originals), originals);
    });

    test('does not duplicate a hero that is already in the list', () {
      const hero = 'https://x.supabase.co/hero.png';
      final result = catalogueImages(heroUrl: hero, originals: const [hero, '/tmp/a.jpg']);

      expect(result.where((e) => e == hero), hasLength(1));
    });

    test('handles a listing with no photos at all', () {
      expect(catalogueImages(heroUrl: null, originals: const []), isEmpty);
      expect(
        catalogueImages(heroUrl: 'https://x/a.png', originals: const []),
        ['https://x/a.png'],
      );
    });

    test('does not alias the caller list', () {
      final originals = ['/tmp/a.jpg'];
      final result = catalogueImages(heroUrl: null, originals: originals);
      result.add('/tmp/b.jpg');

      expect(originals, hasLength(1), reason: 'must not mutate the input');
    });
  });
}
