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
  });

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

  static const products = <Product>[
    Product(
      id: 'p1',
      name: T('Pashmina Shawl', 'पश्मीना शॉल'),
      price: 4850,
      stateId: 'jk',
      artisan: T('Aasha Begum', 'आशा बेगम'),
      material: T('Pure Pashmina wool', 'शुद्ध पश्मीना ऊन'),
      technique: T('Handwoven', 'हाथ से बुना'),
      hours: 96,
      story: T(
        'Spun and woven by hand in Srinagar over four months. The weave is so '
        'fine the shawl passes through a ring.',
        'श्रीनगर में चार महीने तक हाथ से काता और बुना गया। बुनाई इतनी बारीक है '
        'कि यह शॉल एक अंगूठी से निकल जाती है।',
      ),
      seed: 0,
      icon: Icons.checkroom_rounded,
    ),
    Product(
      id: 'p2',
      name: T('Brass Kuthu Vilakku', 'पीतल कुत्थु विलक्कु'),
      price: 2650,
      stateId: 'tn',
      artisan: T('R. Karthikeyan', 'आर. कार्तिकेयन'),
      material: T('Cast brass', 'ढला हुआ पीतल'),
      technique: T('Lost wax casting', 'मोम विधि से ढलाई'),
      hours: 22,
      story: T(
        'Cast in Swamimalai using the lost wax method his family has used for '
        'six generations.',
        'स्वामिमलाई में छह पीढ़ियों से चली आ रही मोम विधि से ढाला गया।',
      ),
      seed: 3,
      icon: Icons.local_fire_department_outlined,
    ),
    Product(
      id: 'p3',
      name: T('Handblock Tote Bag', 'हैंडब्लॉक टोट बैग'),
      price: 1250,
      stateId: 'rj',
      artisan: T('Meena Chaudhary', 'मीना चौधरी'),
      material: T('Cotton canvas', 'सूती कैनवास'),
      technique: T('Hand block print', 'हाथ की छपाई'),
      hours: 7,
      story: T(
        'Printed in Bagru with carved teak blocks and natural indigo dye.',
        'बगरू में सागौन के ब्लॉक और प्राकृतिक नील से छपा हुआ।',
      ),
      seed: 5,
      icon: Icons.shopping_bag_outlined,
    ),
    Product(
      id: 'p4',
      name: T('Kantha Silk Stole', 'कांथा सिल्क स्टोल'),
      price: 1980,
      stateId: 'wb',
      artisan: T('Sabita Das', 'सबिता दास'),
      material: T('Tussar silk', 'तसर रेशम'),
      technique: T('Kantha running stitch', 'कांथा टाँका'),
      hours: 34,
      story: T(
        'Every stitch is placed by hand. No two stoles are ever the same.',
        'हर टाँका हाथ से लगाया गया है। कोई दो स्टोल एक जैसे नहीं होते।',
      ),
      seed: 1,
      icon: Icons.checkroom_rounded,
    ),
    Product(
      id: 'p5',
      name: T('Blue Pottery Vase', 'नीली मिट्टी का फूलदान'),
      price: 890,
      stateId: 'rj',
      artisan: T('Imran Khan', 'इमरान खान'),
      material: T('Quartz and glaze', 'क्वार्ट्ज़ और शीशा'),
      technique: T('Jaipur blue pottery', 'जयपुर नीली मिट्टी'),
      hours: 12,
      story: T(
        'Made without clay. Quartz, powdered glass and fuller’s earth, fired '
        'once at low heat.',
        'मिट्टी के बिना बना। क्वार्ट्ज़, काँच का चूरा और मुल्तानी मिट्टी, कम '
        'आँच पर एक बार पकाया गया।',
      ),
      seed: 4,
      icon: Icons.coffee_rounded,
    ),
    Product(
      id: 'p6',
      name: T('Dhokra Tribal Figure', 'ढोकरा आदिवासी मूर्ति'),
      price: 3400,
      stateId: 'mp',
      artisan: T('Budhram Maravi', 'बुधराम मरावी'),
      material: T('Bell metal', 'काँसा'),
      technique: T('Dhokra lost wax', 'ढोकरा मोम विधि'),
      hours: 28,
      story: T(
        'A four thousand year old casting technique, still done without a mould '
        'that can be reused.',
        'चार हज़ार साल पुरानी ढलाई तकनीक, आज भी बिना दोबारा इस्तेमाल होने वाले '
        'साँचे के।',
      ),
      seed: 2,
      icon: Icons.emoji_objects_outlined,
    ),
    Product(
      id: 'p7',
      name: T('Pattachitra Scroll', 'पट्टचित्र स्क्रॉल'),
      price: 5600,
      stateId: 'od',
      artisan: T('Bhagyashree Moharana', 'भाग्यश्री मोहराना'),
      material: T('Cloth and natural pigment', 'कपड़ा और प्राकृतिक रंग'),
      technique: T('Pattachitra painting', 'पट्टचित्र चित्रकला'),
      hours: 120,
      story: T(
        'Painted on treated cloth with brushes made from mouse hair, using '
        'colours ground from stone and shell.',
        'तैयार कपड़े पर चूहे के बालों से बने ब्रश और पत्थर व सीप से पीसे गए '
        'रंगों से बनाया गया।',
      ),
      seed: 3,
      icon: Icons.brush_outlined,
    ),
    Product(
      id: 'p8',
      name: T('Bandhani Dupatta', 'बांधनी दुपट्टा'),
      price: 1640,
      stateId: 'gj',
      artisan: T('Hasina Bibi', 'हसीना बीबी'),
      material: T('Georgette', 'जॉर्जेट'),
      technique: T('Tie and dye', 'बाँधकर रंगाई'),
      hours: 18,
      story: T(
        'Over nine thousand knots tied by fingernail before the cloth ever '
        'touches dye.',
        'रंग लगने से पहले नौ हज़ार से ज़्यादा गाँठें नाखून से बाँधी जाती हैं।',
      ),
      seed: 5,
      icon: Icons.checkroom_rounded,
    ),
  ];

  static CraftState stateById(String id) =>
      states.firstWhere((s) => s.id == id, orElse: () => states.first);

  static Product productById(String id) =>
      products.firstWhere((p) => p.id == id, orElse: () => products.first);
}
