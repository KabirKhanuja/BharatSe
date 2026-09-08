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

    // States present in the catalogue that were not in the original
    // twelve. Same shape, so nothing downstream changes.
    CraftState(
      id: 'ap',
      name: T('Andhra Pradesh', 'Andhra Pradesh'),
      crafts: T('Kalamkari, Kondapalli Toys', 'कलमकारी, कोंडापल्ली खिलौने'),
      seed: 0,
      count: 0,
      heritage: T(
        'Andhra Pradesh has an ancient tradition of craft production rooted in rural communities. Kalamkari involves natural dye hand-painting or block printing on cotton fabric, practised mainly in Machilipatnam and Srikalahasti. Kondapalli artisans carve light softwood into figures, animals, and mythological representations using local vegetable dyes. These crafts continue to be sustained through cooperative societies and village clusters.',
        'आंध्र प्रदेश में ग्रामीण समुदायों से जुड़ी शिल्प निर्माण की एक प्राचीन परंपरा है। कलमकारी में सूती कपड़े पर प्राकृतिक रंगों से हाथ से चित्रकारी या ब्लॉक प्रिंटिंग की जाती है, जो मुख्य रूप से मछलीपट्टनम और श्रीकालहस्ती में प्रचलित है। कोंडापल्ली के कारीगर हल्की नरम लकड़ी को तराशकर देवी-देवताओं, इंसानों और जानवरों के खिलौने बनाते हैं। ये पारंपरिक कलाएं आज भी सहकारी समितियों और ग्रामीण केंद्रों के माध्यम से जारी हैं।',
      ),
    ),
    CraftState(
      id: 'ar',
      name: T('Arunachal Pradesh', 'Arunachal Pradesh'),
      crafts: T('Monpa Wood Carving, Apatani Weaving', 'मोनपा लकड़ी की नक्काशी, अपातानी बुनाई'),
      seed: 1,
      count: 0,
      heritage: T(
        'The craft practices of Arunachal Pradesh reflect the daily needs and cultural identities of its diverse tribes. Monpa artisans in Tawang carve bowls, masks, and low tables from local timber, often painting them with traditional motifs. Weavers in the Apatani valley produce textiles with distinctive geometric patterns on backstrap tension looms. These crafts utilize forest resources like bamboo, cane, and wood without mechanized processes.',
        'अरुणाचल प्रदेश की शिल्प परंपराएं यहां की विभिन्न जनजातियों की दैनिक जरूरतों और सांस्कृतिक पहचान को दर्शाती हैं। तवांग में मोनपा कारीगर स्थानीय लकड़ी से कटोरे, मुखौटे और छोटी मेजें तराशते हैं और उन पर पारंपरिक रूपांकन उकेरते हैं। अपातानी घाटी के बुनकर बैकस्ट्रैप लूम पर विशिष्ट ज्यामितीय आकृतियों वाले वस्त्र तैयार करते हैं। इन शिल्पों में बांस, बेंत और लकड़ी जैसे वन संसाधनों का बिना मशीनों के उपयोग किया जाता है।',
      ),
    ),
    CraftState(
      id: 'as',
      name: T('Assam', 'Assam'),
      crafts: T('Muga Silk Weaving, Cane and Bamboo Crafts', 'मूगा रेशम बुनाई, बेंत और बांस शिल्प'),
      seed: 2,
      count: 0,
      heritage: T(
        'Assam has a widespread culture of domestic weaving where handlooms are found in many rural homes. Muga silk, known for its natural golden sheen, is woven into traditional garments such as the Mekhela Chador. The state also possesses vast bamboo and cane reserves which artisans fashion into domestic utensils, fishing traps, and furniture. Most of these goods are produced using simple hand tools passed down through generations.',
        'असम में घरेलू बुनाई की व्यापक संस्कृति है जहां कई ग्रामीण घरों में हथकरघे पाए जाते हैं। मूगा रेशम अपनी प्राकृतिक सुनहरी चमक के लिए जाना जाता है, जिससे मेखेला चादर जैसे पारंपरिक परिधान बुने जाते हैं। राज्य में बांस और बेंत का भी प्रचुर भंडार है, जिसे कारीगर घरेलू बर्तनों, मछली पकड़ने के औजारों और फर्नीचर में ढालते हैं। इनमें से अधिकांश वस्तुएं पीढ़ियों से चले आ रहे साधारण औजारों से बनाई जाती हैं।',
      ),
    ),
    CraftState(
      id: 'br',
      name: T('Bihar', 'Bihar'),
      crafts: T('Madhubani Painting, Sikki Grass Craft', 'मधुबनी पेंटिंग, सिक्की घास शिल्प'),
      seed: 3,
      count: 0,
      heritage: T(
        'Craft traditions in Bihar are closely linked to ritual practices and domestic life. Madhubani painting originated as wall murals created by women during festivals and rites of passage, using natural pigments. Sikki grass craft involves collecting wild golden grass and coiling it into storage containers, baskets, and decorative figures. Both crafts provide non-farm livelihoods for women in northern Bihar.',
        'बिहार की शिल्प परंपराएं रीति-रिवाजों और घरेलू जीवन से गहराई से जुड़ी हुई हैं। मधुबनी पेंटिंग की शुरुआत महिलाओं द्वारा त्योहारों और शुभ अवसरों पर दीवारों पर प्राकृतिक रंगों से चित्र बनाने से हुई थी। सिक्की घास शिल्प में सुनहरी घास को इकट्ठा करके उससे टोकरियां, भंडारण पात्र और आकृतियां बनाई जाती हैं। ये दोनों शिल्प उत्तर बिहार की महिलाओं को आजीविका के साधन प्रदान करते हैं।',
      ),
    ),
    CraftState(
      id: 'cg',
      name: T('Chhattisgarh', 'Chhattisgarh'),
      crafts: T('Dhokra Metal Casting, Terracotta Craft', 'ढोकरा धातु ढलाई, टेराकोटा शिल्प'),
      seed: 4,
      count: 0,
      heritage: T(
        'Chhattisgarh has a strong tribal craft base centered around forest and earth materials. Dhokra casting uses the ancient lost-wax technique with brass scrap to produce figures of deities, musicians, and animals. Terracotta pottery in regions like Bastar is crafted into ritual vessels, roof tiles, and votive animals. Artisans rely on local clay, firewood, and beeswax for their production.',
        'छत्तीसगढ़ की जनजातीय शिल्प परंपराएं जंगल और मिट्टी से जुड़े संसाधनों पर आधारित हैं। ढोकरा ढलाई में पीतल की धातु से मोम-पिघलाने की प्राचीन विधि द्वारा देवी-देवताओं और पशुओं की मूर्तियां बनाई जाती हैं। बस्तर जैसे क्षेत्रों में टेराकोटा कारीगर अनुष्ठानिक बर्तन, खपरैल और मन्नत की आकृतियां तैयार करते हैं। कारीगर इन शिल्पों के लिए स्थानीय मिट्टी, लकड़ी और मधुमक्खी के मोम का उपयोग करते हैं।',
      ),
    ),
    CraftState(
      id: 'ga',
      name: T('Goa', 'Goa'),
      crafts: T('Coconut Shell Craft, Terracotta Pottery', 'नारियल के खोल का शिल्प, टेराकोटा मिट्टी के बर्तन'),
      seed: 5,
      count: 0,
      heritage: T(
        'Goan crafts draw upon coastal materials and local village utility needs. Coconut shell carving utilizes discarded shells to make bowls, spoons, and carved decorative items. Terracotta potters shape earthenware cooking pots, water pitchers, and roofing tiles. These utilitarian items continue to be sold at local weekly village markets across the state.',
        'गोवा के शिल्प तटीय संसाधनों और स्थानीय ग्रामीण आवश्यकताओं पर आधारित हैं। नारियल के खोल से कटोरे, चम्मच और नक्काशीदार सजावटी वस्तुएं बनाई जाती हैं। टेराकोटा कुम्हार मिट्टी के खाना पकाने के बर्तन, मटके और छत के खपरैल तैयार करते हैं। ये उपयोगी वस्तुएं आज भी राज्य भर के स्थानीय साप्ताहिक ग्रामीण बाजारों में बेची जाती हैं।',
      ),
    ),
    CraftState(
      id: 'hr',
      name: T('Haryana', 'Haryana'),
      crafts: T('Panja Dhurrie, Clay Pottery', 'पंजा दरी, मिट्टी के बर्तन'),
      seed: 0,
      count: 0,
      heritage: T(
        'The craft tradition of Haryana is primarily rural and utility-focused. Panja dhurries are flat-woven cotton rugs crafted on horizontal frames using a heavy iron fork called a panja. Village potters across districts like Jhajjar produce clay water coolers and domestic pots suited to the dry climate. Woodworkers also create agricultural implements and basic domestic furniture for local use.',
        'हरियाणा की शिल्प परंपरा मुख्य रूप से ग्रामीण और व्यावहारिक उपयोग पर केंद्रित है। पंजा दरियां लोहे के पंजे जैसे औजार की मदद से क्षैतिज करघों पर बुनी जाने वाली सूती दरियां हैं। झज्जर जैसे जिलों के ग्रामीण कुम्हार शुष्क मौसम के अनुकूल मिट्टी के मटके और अन्य घरेलू बर्तन बनाते हैं। इसके अलावा स्थानीय बढ़ई खेती के औजार और सामान्य घरेलू फर्नीचर का निर्माण करते हैं।',
      ),
    ),
    CraftState(
      id: 'jh',
      name: T('Jharkhand', 'Jharkhand'),
      crafts: T('Sohrai Khovar Painting, Bamboo Basketry', 'सोहराई खोवर चित्रकला, बांस की टोकरी निर्माण'),
      seed: 1,
      count: 0,
      heritage: T(
        'Jharkhand\'s crafts are deeply intertwined with indigenous harvest and marriage ceremonies. Sohrai and Khovar paintings are done using natural earth pigments on mud walls, depicting flora, fauna, and geometric forms. Bamboo artisans weave varied baskets, winnowing trays, and grain containers for rural households. These items are made without chemical treatments or modern power machinery.',
        'झारखंड के शिल्प स्थानीय जनजातियों के फसल और विवाह उत्सवों से गहराई से जुड़े हैं। सोहराई और खोवर चित्रकला मिट्टी की दीवारों पर प्राकृतिक रंगों से बनाई जाती है, जिसमें पेड़-पौधों और जानवरों के चित्र होते हैं। बांस कारीगर ग्रामीण घरों के लिए विभिन्न टोकरियां, सूप और अनाज रखने के पात्र बुनते हैं। ये वस्तुएं बिना किसी रासायनिक प्रक्रिया या आधुनिक मशीनों के बनाई जाती हैं।',
      ),
    ),
    CraftState(
      id: 'ml',
      name: T('Meghalaya', 'Meghalaya'),
      crafts: T('Ryndia Silk Weaving, Cane and Bamboo Mats', 'रिंदिया रेशम बुनाई, बेंत और बांस की चटाई'),
      seed: 2,
      count: 0,
      heritage: T(
        'Meghalaya utilizes its forest wealth and sericulture traditions to produce everyday goods. Ryndia, or Eri silk, is hand-spun and handwoven by Khasi and Ri-Bhoi weavers using plant-based natural dyes. Skilled craftspeople also weave fine cane mats and a variety of weather-resistant bamboo baskets. The craft production remains largely household-based and seasonal, fitted around agricultural work.',
        'मेघालय दैनिक उपयोग की वस्तुएं बनाने के लिए अपने वन संसाधनों और रेशम परंपरा का उपयोग करता है। रिंदिया (एरी रेशम) को खासी और री-भोई की बुनकर महिलाएं हाथ से कातकर प्राकृतिक रंगों से बुनती हैं। इसके अलावा कारीगर बेंत की चटाइयों और मौसम रोधी बांस की टोकरियों का निर्माण करते हैं। यह शिल्प उत्पादन मुख्य रूप से घरेलू स्तर पर और खेती के मौसम के अनुसार किया जाता है।',
      ),
    ),
    CraftState(
      id: 'mz',
      name: T('Mizoram', 'Mizoram'),
      crafts: T('Puan Weaving, Bamboo Basketry', 'पुआन बुनाई, बांस की टोकरी निर्माण'),
      seed: 3,
      count: 0,
      heritage: T(
        'Mizo craft traditions focus strongly on handloom weaving and cane work. Women weave the Puan, a traditional wrap skirt, on loin looms using distinct geometric colour bands that indicate clan and occasion. Mizoram\'s dense bamboo forests provide raw material for making a variety of carrying baskets, including the conical Paikawng. Production is mostly home-based and manual, meeting local community requirements.',
        'मिज़ो शिल्प परंपराएं मुख्य रूप से हथकरघा बुनाई और बेंत-बांस के काम पर केंद्रित हैं। महिलाएं कमर के करघे पर \'पुआन\' नामक पारंपरिक वस्त्र बुनती हैं, जिसमें विशेष रंग और ज्यामितीय पैटर्न होते हैं। मिज़ोरम के घने बांस के जंगलों से विभिन्न प्रकार की टोकरियां और सामान ले जाने वाले बर्तन बनाए जाते हैं। यह उत्पादन घर-घर में हाथ से किया जाता है और स्थानीय जरूरतों को पूरा करता है।',
      ),
    ),
    CraftState(
      id: 'nl',
      name: T('Nagaland', 'Nagaland'),
      crafts: T('Naga Shawl Weaving, Wood Carving', 'नागा शॉल बुनाई, लकड़ी की नक्काशी'),
      seed: 4,
      count: 0,
      heritage: T(
        'Nagaland\'s crafts are rooted in the cultural identities of its sixteen major tribes. Naga shawls are woven on body-tension backstrap looms, with patterns, colors, and motifs that historically signified social standing. Woodcarvers work with single blocks of wood to shape village gateposts, ceremonial cups, and animal heads. These craft skills are passed down orally and through observation in village settings.',
        'नागालैंड की शिल्प परंपराएं यहां की सोलह प्रमुख जनजातियों की सांस्कृतिक पहचान से जुड़ी हैं। नागा शॉल बैकस्ट्रैप लूम पर बुने जाते हैं, जिनके पैटर्न और रंग सामाजिक स्थिति को दर्शाते हैं। लकड़ी तराशने वाले कारीगर लकड़ी के एक ही लट्ठे से गांव के द्वार, पारंपरिक कप और सजावटी आकृतियां बनाते हैं। यह शिल्प कौशल गांवों में मौखिक रूप से और देखकर सीखने के माध्यम से एक पीढ़ी से दूसरी पीढ़ी तक पहुंचता है।',
      ),
    ),
    CraftState(
      id: 'pb',
      name: T('Punjab', 'Punjab'),
      crafts: T('Phulkari Embroidery, Mudda Making', 'फुलकारी कढ़ाई, मुड्ढा निर्माण'),
      seed: 5,
      count: 0,
      heritage: T(
        'Punjab\'s domestic craft heritage is closely linked to village social life. Phulkari is a traditional embroidery technique where untwisted silk floss is worked on coarse khaddar cotton from the reverse side. Sarkanda grass and bamboo reeds are harvested locally to make durable low stools called muddas. These crafts were traditionally made for household use and wedding trousseaus rather than commercial trade.',
        'पंजाब की घरेलू शिल्प परंपरा ग्रामीण सामाजिक जीवन से जुड़ी हुई है। फुलकारी एक पारंपरिक कढ़ाई कला है जिसमें मोटे खद्दर के कपड़े पर उल्टी तरफ से रेशमी धागे से कढ़ाई की जाती है। स्थानीय सरकंडा घास और बांस की मदद से टिकाऊ बैठने के मूढ़े बनाए जाते हैं। ये वस्तुएं पारंपरिक रूप से व्यावसायिक बिक्री के बजाय घरेलू उपयोग और शादी-ब्याह के लिए तैयार की जाती थीं।',
      ),
    ),
    CraftState(
      id: 'sk',
      name: T('Sikkim', 'Sikkim'),
      crafts: T('Thangka Painting, Choktse Wood Carving', 'थंगका चित्रकला, चोकत्से लकड़ी नक्काशी'),
      seed: 0,
      count: 0,
      heritage: T(
        'Sikkim\'s crafts are heavily influenced by Tibetan Buddhist traditions and monastic culture. Thangka painting involves rendering Buddhist deities and mandalas on cotton or silk canvas according to exact iconographic rules. Choktse artisans hand-carve foldable wooden tables with relief motifs like dragons and lotus flowers before painting them. These crafts are taught systematically in traditional state-run institutes to ensure standard preservation.',
        'सिक्किम की शिल्प कलाएं तिब्बती बौद्ध परंपराओं और मठ संस्कृति से काफी प्रभावित हैं। थंगका चित्रकला में सूती या रेशमी कपड़े पर तय धार्मिक नियमों के अनुसार बौद्ध देवी-देवताओं और मंडलों के चित्र बनाए जाते हैं। चोकत्से कारीगर लकड़ी की तह होने वाली छोटी मेजों पर ड्रैगन और कमल जैसी नक्काशी करते हैं और उन्हें रंगते हैं। इन शिल्पों को संरक्षित रखने के लिए पारंपरिक संस्थानों में व्यवस्थित रूप से सिखाया जाता है।',
      ),
    ),
    CraftState(
      id: 'tr',
      name: T('Tripura', 'Tripura'),
      crafts: T('Cane and Bamboo Furniture, Risa Handloom Weaving', 'बेंत और बांस का फर्नीचर, रीसा हथकरघा बुनाई'),
      seed: 1,
      count: 0,
      heritage: T(
        'Crafts in Tripura are defined by the widespread abundance of bamboo species and indigenous weaving methods. Artisans make partitions, screens, baskets, and lightweight furniture using split cane and treated bamboo. Women from tribal communities weave Risa, a traditional narrow cloth, on loin looms using cotton yarns. Craft production serves both rural utility and organised cottage enterprise across the state.',
        'त्रिपुरा के शिल्प प्रचुर मात्रा में मिलने वाले बांस और पारंपरिक बुनाई तकनीकों पर आधारित हैं। कारीगर बांस और बेंत की तीलियों से पर्दे, टोकरियां और हल्का फर्नीचर तैयार करते हैं। जनजातीय समुदायों की महिलाएं कमर के करघे पर \'रीसा\' नामक पारंपरिक सूती कपड़ा बुनती हैं। यह शिल्प उत्पादन राज्य में घरेलू उपयोग और कुटीर उद्योगों दोनों का एक महत्वपूर्ण हिस्सा है।',
      ),
    ),
    CraftState(
      id: 'ts',
      name: T('Telangana', 'Telangana'),
      crafts: T('Pochampally Ikat, Bidriware', 'पोचमपल्ली इकत, बिदरी क्राफ्ट'),
      seed: 2,
      count: 0,
      heritage: T(
        'Telangana has distinct regional craft hubs with long commercial histories. Pochampally Ikat is a resist-dyeing weaving technique where warp and weft threads are precisely dyed before being woven on pit looms. Bidriware, practised in and around Hyderabad, involves inlaying pure silver wire or sheet into an alloy of zinc and copper, which is then blackened with soil containing sal ammoniac. These trades operate through hereditary master artisan networks and handloom cooperatives.',
        'तेलंगाना में लंबे व्यापारिक इतिहास वाले कई शिल्प केंद्र मौजूद हैं। पोचमपल्ली इकत एक ऐसी बुनाई तकनीक है जिसमें ताने और बाने के धागों को पहले से रंगकर गड्ढा करघे पर बुना जाता है। हैदराबाद और आसपास प्रचलित बिदरी कला में जस्ता और तांबे की मिश्र धातु पर चांदी के तारों की जड़ाई की जाती है और फिर उसे विशेष मिट्टी से काला किया जाता है। ये शिल्प वंशानुगत कारीगरों और हथकरघा सहकारी समितियों द्वारा संचालित होते हैं।',
      ),
    ),
    CraftState(
      id: 'uk',
      name: T('Uttarakhand', 'Uttarakhand'),
      crafts: T('Ringal Bamboo Craft, Aipan Art', 'रिंगाल बांस शिल्प, ऐपण कला'),
      seed: 3,
      count: 0,
      heritage: T(
        'Uttarakhand\'s craft traditions reflect the geography of the Himalayan foothills and domestic rituals. Ringal, a dwarf hill bamboo, is harvested in Garhwal and Kumaon to weave durable mats, grain baskets, and household utilities. Aipan is a ritualistic floor and wall art practised by women using a red clay base and white rice paste. These crafts depend entirely on seasonal mountain resources and household participation.',
        'उत्तराखंड की शिल्प परंपराएं हिमालयी भूगोल और घरेलू अनुष्ठानों को दर्शाती हैं। गढ़वाल और कुमाऊं में रिंगाल (पहाड़ी बांस) से मजबूत चटाइयां, अनाज की टोकरियां और घरेलू बर्तन बुने जाते हैं। ऐपण महिलाओं द्वारा गेरू की लाल पृष्ठभूमि पर चावल के घोल से बनाई जाने वाली पारंपरिक फर्श और दीवार कला है। ये शिल्प पूरी तरह से मौसमी पहाड़ी संसाधनों और घरेलू भागीदारी पर निर्भर हैं।',
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
