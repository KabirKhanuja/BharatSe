import 'package:flutter/material.dart';
import '../l10n/lang.dart';

/// Demo catalogue.
///
/// Stands in for the API. Content carries both languages so switching the
/// interface language changes the CONTENT too, not just the chrome. When the
/// backend lands this file is replaced by a repository; nothing above it moves.

class CraftState {
  const CraftState({
    required this.id,
    required this.name,
    required this.crafts,
    required this.seed,
    required this.count,
    required this.heritage,
  });

  final String id;
  final T name;
  final T crafts;
  final int seed;
  final int count;

  /// What the craft is and where it came from.
  final T heritage;
}

class CraftCategory {
  const CraftCategory({required this.id, required this.name, required this.icon});
  final String id;
  final T name;
  final IconData icon;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stateId,
    required this.artisan,
    required this.material,
    required this.technique,
    required this.hours,
    required this.story,
    required this.seed,
    required this.icon,
    this.imageUrl,
  });

  /// Built from the catalogue API.
  ///
  /// The screens keep speaking [Product], so swapping the hardcoded list for
  /// live rows touches this file and nothing above it. Hindi falls back to
  /// English rather than showing an empty string, because a listing with a
  /// blank title reads as broken.
  factory Product.fromApi(Map<String, dynamic> json) {
    String pick(String primary, String fallback) {
      final value = json[primary] as String?;
      if (value != null && value.trim().isNotEmpty) return value;
      return (json[fallback] as String?) ?? '';
    }

    final titleEn = pick('title_en', 'title_hi');
    final titleHi = pick('title_hi', 'title_en');
    final descEn = pick('description_en', 'description_hi');
    final descHi = pick('description_hi', 'description_en');
    final id = json['id'] as String? ?? '';

    return Product(
      id: id,
      name: T(titleEn, titleHi),
      price: (json['price'] as num?)?.toInt() ?? 0,
      // The database stores state codes uppercase; our own ids are lowercase.
      stateId: (json['state_code'] as String? ?? '').toLowerCase(),
      artisan: T(
        (json['artisan'] as Map<String, dynamic>?)?['name'] as String? ?? '',
        (json['artisan'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      ),
      material: T(json['material'] as String? ?? '', json['material'] as String? ?? ''),
      technique: T(json['technique'] as String? ?? '', json['technique'] as String? ?? ''),
      hours: 0,
      story: T(descEn, descHi),
      // Stable per product, so a placeholder does not change colour on rebuild.
      seed: id.hashCode.abs() % 6,
      icon: Icons.checkroom_rounded,
      imageUrl: json['primary_image_url'] as String?,
    );
  }

  final String id;
  final T name;
  final int price;
  final String stateId;
  final T artisan;
  final T material;
  final T technique;
  final int hours;
  final T story;
  final int seed;
  final IconData icon;

  /// The stored photograph, preferring the enhanced version. Null for the
  /// seeded demo entries, which fall back to a placeholder.
  final String? imageUrl;
}

abstract final class Catalog {
  static const states = <CraftState>[
    CraftState(
      id: 'jk',
      name: T('Jammu & Kashmir', 'जम्मू और कश्मीर'),
      crafts: T('Pashmina, Carpets', 'पश्मीना, कालीन'),
      seed: 0,
      count: 128,
      heritage: T(
        'Pashmina comes from the undercoat of the changthangi goat, combed by hand in Ladakh and spun in Srinagar. A single shawl can take four months at the loom.',
        'पश्मीना चांगथांगी बकरी के भीतरी ऊन से बनता है, जिसे लद्दाख में हाथ से निकाला और श्रीनगर में काता जाता है। एक शॉल बुनने में चार महीने तक लग जाते हैं।',
      ),
    ),
    CraftState(
      id: 'rj',
      name: T('Rajasthan', 'राजस्थान'),
      crafts: T('Block Prints, Jewellery', 'ब्लॉक प्रिंट, गहने'),
      seed: 1,
      count: 214,
      heritage: T(
        'Bagru and Sanganer print cloth with hand carved teak blocks and dyes made from indigo, pomegranate rind and iron. Every repeat is placed by eye.',
        'बगरू और सांगानेर में सागौन के हाथ से गढ़े ब्लॉक और नील, अनार के छिलके तथा लोहे से बने रंगों से छपाई होती है। हर छाप आँख के अंदाज़ से लगती है।',
      ),
    ),
    CraftState(
      id: 'gj',
      name: T('Gujarat', 'गुजरात'),
      crafts: T('Bandhani, Patola', 'बांधनी, पटोला'),
      seed: 2,
      count: 167,
      heritage: T(
        'Bandhani is tied before it is dyed. Thousands of tiny knots are made with the fingernail, then opened to reveal the pattern underneath.',
        'बांधनी पहले बाँधी जाती है, फिर रंगी जाती है। नाखून से हज़ारों छोटी गाँठें लगाई जाती हैं, और खोलने पर नीचे का डिज़ाइन दिखता है।',
      ),
    ),
    CraftState(
      id: 'mh',
      name: T('Maharashtra', 'महाराष्ट्र'),
      crafts: T('Paithani, Warli', 'पैठणी, वारली'),
      seed: 3,
      count: 143,
      heritage: T(
        'Paithani weaving carries no printed design. The motifs are built thread by thread on the loom, which is why a sari can take a year.',
        'पैठणी में कोई छपा हुआ डिज़ाइन नहीं होता। बूटे करघे पर धागा दर धागा बनते हैं, इसीलिए एक साड़ी में साल भर लग सकता है।',
      ),
    ),
    CraftState(
      id: 'wb',
      name: T('West Bengal', 'पश्चिम बंगाल'),
      crafts: T('Kantha, Terracotta', 'कांथा, टेराकोटा'),
      seed: 4,
      count: 189,
      heritage: T(
        'Kantha began as thrift. Worn saris were layered and stitched together, and the running stitch that held them became the art itself.',
        'कांथा की शुरुआत बचत से हुई। पुरानी साड़ियों को परतों में रखकर सिला जाता था, और उन्हें जोड़ने वाला टाँका ही कला बन गया।',
      ),
    ),
    CraftState(
      id: 'tn',
      name: T('Tamil Nadu', 'तमिल नाडु'),
      crafts: T('Kanjivaram, Brass', 'कांजीवरम, पीतल'),
      seed: 5,
      count: 176,
      heritage: T(
        'Swamimalai casts bronze the way the Cholas did, in a mould that must be broken to free the figure. No two pieces can ever be identical.',
        'स्वामिमलाई में चोल काल की तरह काँसा ढाला जाता है, ऐसे साँचे में जिसे मूर्ति निकालने के लिए तोड़ना पड़ता है। इसलिए कोई दो मूर्तियाँ एक जैसी नहीं होतीं।',
      ),
    ),
    CraftState(
      id: 'up',
      name: T('Uttar Pradesh', 'उत्तर प्रदेश'),
      crafts: T('Chikankari, Zardozi', 'चिकनकारी, ज़रदोज़ी'),
      seed: 1,
      count: 231,
      heritage: T(
        'Chikankari is white thread on white cloth, worked in Lucknow in more than thirty stitches, several of which are read from the reverse side.',
        'चिकनकारी सफ़ेद कपड़े पर सफ़ेद धागे का काम है, जो लखनऊ में तीस से ज़्यादा टाँकों में किया जाता है, जिनमें कई उल्टी तरफ़ से पढ़े जाते हैं।',
      ),
    ),
    CraftState(
      id: 'hp',
      name: T('Himachal Pradesh', 'हिमाचल प्रदेश'),
      crafts: T('Shawls, Woollens', 'शॉल, ऊनी कपड़े'),
      seed: 3,
      count: 94,
      heritage: T(
        'Kullu shawls carry geometric borders in undyed sheep wool, woven on pit looms in valleys where the wool has to last a winter.',
        'कुल्लू शॉल में बिना रंगी भेड़ की ऊन से ज्यामितीय किनारे बुने जाते हैं, उन घाटियों के गड्ढा करघों पर जहाँ ऊन को पूरी सर्दी चलना होता है।',
      ),
    ),
    CraftState(
      id: 'od',
      name: T('Odisha', 'ओडिशा'),
      crafts: T('Pattachitra, Filigree', 'पट्टचित्र, तारकशी'),
      seed: 2,
      count: 112,
      heritage: T(
        'Pattachitra is painted on cloth stiffened with tamarind paste, using brushes made from animal hair and colours ground from stone and shell.',
        'पट्टचित्र इमली की लेई से कड़े किए कपड़े पर बनता है, जानवरों के बाल के ब्रश और पत्थर व सीप से पीसे रंगों से।',
      ),
    ),
    CraftState(
      id: 'ka',
      name: T('Karnataka', 'कर्नाटक'),
      crafts: T('Mysore Silk, Sandalwood', 'मैसूर सिल्क, चंदन'),
      seed: 4,
      count: 158,
      heritage: T(
        'Channapatna toys are turned on a lathe from ivory wood and coloured with lac, a resin polished to a shine with a screw pine leaf.',
        'चन्नपटना के खिलौने हाथी दाँत की लकड़ी से खराद पर बनते हैं और लाख से रंगे जाते हैं, जिसे केवड़े के पत्ते से चमकाया जाता है।',
      ),
    ),
    CraftState(
      id: 'kl',
      name: T('Kerala', 'केरल'),
      crafts: T('Kasavu, Coir', 'कसावु, कॉयर'),
      seed: 5,
      count: 87,
      heritage: T(
        'Kasavu is plain cream cotton with a gold border, woven in Balaramapuram on throw shuttle looms that have barely changed in two centuries.',
        'कसावु सादा क्रीम सूती कपड़ा है जिसके किनारे पर सुनहरी ज़री होती है, जो बलरामपुरम के उन करघों पर बुना जाता है जो दो सदियों में मुश्किल से बदले हैं।',
      ),
    ),
    CraftState(
      id: 'mp',
      name: T('Madhya Pradesh', 'मध्य प्रदेश'),
      crafts: T('Bamboo, Dhokra', 'बाँस, ढोकरा'),
      seed: 0,
      count: 103,
      heritage: T(
        'Dhokra has been cast for more than four thousand years. The wax model is destroyed in the making, so the object can never be repeated.',
        'ढोकरा चार हज़ार साल से ढाला जा रहा है। मोम का नमूना बनाते समय ही नष्ट हो जाता है, इसलिए वही चीज़ दोबारा नहीं बन सकती।',
      ),
    ),
  ];

  static const categories = <CraftCategory>[
    CraftCategory(
        id: 'textiles', name: T('Textiles', 'वस्त्र'), icon: Icons.checkroom_rounded),
    CraftCategory(
        id: 'pottery', name: T('Pottery', 'मिट्टी के बर्तन'), icon: Icons.coffee_rounded),
    CraftCategory(
        id: 'jewellery', name: T('Jewellery', 'गहने'), icon: Icons.diamond_outlined),
    CraftCategory(
        id: 'woodwork', name: T('Woodwork', 'लकड़ी का काम'), icon: Icons.forest_outlined),
    CraftCategory(
        id: 'metal', name: T('Metalwork', 'धातु का काम'), icon: Icons.hardware_outlined),
    CraftCategory(
        id: 'painting', name: T('Painting', 'चित्रकला'), icon: Icons.brush_outlined),
    CraftCategory(
        id: 'bamboo', name: T('Bamboo & Cane', 'बाँस और बेंत'), icon: Icons.grass_outlined),
    CraftCategory(
        id: 'leather', name: T('Leather', 'चमड़ा'), icon: Icons.work_outline_rounded),
  ];

  /// Products are no longer held here. They come from the catalogue API and
  /// live in [AppState.catalogProducts], because they are data with a table
  /// behind them. What stays in this file is editorial: the states, their
  /// crafts, and the heritage notes, none of which the database models.

  static CraftState stateById(String id) =>
      states.firstWhere((s) => s.id == id, orElse: () => states.first);

  /// Whether we carry anything from this state.
  static bool hasState(String id) => states.any((s) => s.id == id);

  /// A state we hold no products for yet.
  ///
  /// Built rather than faked: the name comes from the map data, and the copy
  /// says plainly that nothing is listed yet instead of showing an empty grid
  /// under a heading that implies there should be something.
  static CraftState placeholderFor(String id, String name) => CraftState(
        id: id,
        name: T(name, name),
        crafts: const T('Not listed yet', 'अभी सूचीबद्ध नहीं'),
        seed: id.hashCode.abs() % 6,
        count: 0,
        heritage: const T(
          'No artisans from this state have listed on BharatSe yet. As the '
          'programme reaches more clusters, their work will appear here.',
          'इस राज्य के कारीगरों ने अभी BharatSe पर कुछ नहीं डाला है। जैसे जैसे '
          'योजना और क्लस्टर तक पहुँचेगी, उनका काम यहाँ दिखने लगेगा।',
        ),
      );


}
