/// The languages the interface itself is available in.
///
/// This is separate from the languages an artisan may SPEAK into the app.
/// She can dictate in any Indian language; the chrome around her is
/// translated only where we have reviewed the wording.
enum Lang {
  en('English', 'English'),
  hi('हिन्दी', 'Hindi'),
  mr('मराठी', 'Marathi'),
  bn('বাংলা', 'Bengali'),
  ta('தமிழ்', 'Tamil'),
  te('తెలుగు', 'Telugu'),
  gu('ગુજરાતી', 'Gujarati'),
  kn('ಕನ್ನಡ', 'Kannada'),
  od('ଓଡ଼ିଆ', 'Odia'),
  pa('ਪੰਜਾਬੀ', 'Punjabi');

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

class ProfileStrings {
  const ProfileStrings({
    required this.myOrders,
    required this.wishlist,
    required this.addresses,
    required this.language,
    required this.help,
    required this.about,
    required this.switchToSeller,
    required this.sellerModeSub,
    required this.chooseLanguage,
    required this.guestName,
    required this.guestSub,
    required this.signIn,
  });

  final String myOrders;
  final String wishlist;
  final String addresses;
  final String language;
  final String help;
  final String about;
  final String switchToSeller;
  final String sellerModeSub;
  final String chooseLanguage;
  final String guestName;
  final String guestSub;
  final String signIn;

  static const en = ProfileStrings(
    myOrders: 'My orders',
    wishlist: 'Saved items',
    addresses: 'Delivery addresses',
    language: 'Language',
    help: 'Help and support',
    about: 'About BharatSe',
    switchToSeller: 'Switch to artisan view',
    sellerModeSub: 'List your craft and reach buyers across India',
    chooseLanguage: 'Choose language',
    guestName: 'Guest',
    guestSub: 'Sign in to track orders and save favourites',
    signIn: 'Sign in',
  );

  static const hi = ProfileStrings(
    myOrders: 'मेरे ऑर्डर',
    wishlist: 'सहेजी गई चीज़ें',
    addresses: 'डिलीवरी पते',
    language: 'भाषा',
    help: 'मदद और सहायता',
    about: 'BharatSe के बारे में',
    switchToSeller: 'कारीगर व्यू पर जाएँ',
    sellerModeSub: 'अपना शिल्प डालें और पूरे भारत तक पहुँचें',
    chooseLanguage: 'भाषा चुनें',
    guestName: 'अतिथि',
    guestSub: 'ऑर्डर देखने और पसंद सहेजने के लिए साइन इन करें',
    signIn: 'साइन इन करें',
  );

  static const mr = ProfileStrings(
    myOrders: 'माझ्या ऑर्डर्स',
    wishlist: 'जतन केलेल्या वस्तू',
    addresses: 'डिलिव्हरीचे पत्ते',
    language: 'भाषा',
    help: 'मदत आणि सहाय्य',
    about: 'BharatSe विषयी',
    switchToSeller: 'कारागीर दृश्यावर जा',
    sellerModeSub: 'तुमची कला दाखवा आणि संपूर्ण भारतातील ग्राहकांपर्यंत पोहोचा',
    chooseLanguage: 'भाषा निवडा',
    guestName: 'पाहुणे',
    guestSub: 'ऑर्डर पाहण्यासाठी आणि आवडीच्या वस्तू जतन करण्यासाठी साइन इन करा',
    signIn: 'साइन इन करा',
  );

  static const bn = ProfileStrings(
    myOrders: 'আমার অর্ডার',
    wishlist: 'সংরক্ষিত পণ্য',
    addresses: 'ডেলিভারি ঠিকানা',
    language: 'ভাষা',
    help: 'সাহায্য ও সহায়তা',
    about: 'BharatSe সম্পর্কে',
    switchToSeller: 'কারিগর ভিউতে যান',
    sellerModeSub:
        'আপনার কারুশিল্প তালিকাভুক্ত করে সারা ভারতের ক্রেতাদের কাছে পৌঁছান',
    chooseLanguage: 'ভাষা নির্বাচন করুন',
    guestName: 'অতিথি',
    guestSub: 'অর্ডার দেখতে এবং পছন্দের জিনিস সংরক্ষণ করতে সাইন ইন করুন',
    signIn: 'সাইন ইন করুন',
  );

  static const ta = ProfileStrings(
    myOrders: 'எனது ஆர்டர்கள்',
    wishlist: 'சேமித்த பொருட்கள்',
    addresses: 'டெலிவரி முகவரிகள்',
    language: 'மொழி',
    help: 'உதவி மற்றும் ஆதரவு',
    about: 'BharatSe பற்றி',
    switchToSeller: 'கைவினைஞர் பார்வைக்கு மாறவும்',
    sellerModeSub:
        'உங்கள் கைவினையைப் பட்டியலிட்டு இந்தியா முழுவதும் வாங்குபவர்களை அடையுங்கள்',
    chooseLanguage: 'மொழியைத் தேர்ந்தெடுக்கவும்',
    guestName: 'விருந்தினர்',
    guestSub:
        'ஆர்டர்களைக் கண்காணிக்கவும் பிடித்தவற்றைச் சேமிக்கவும் உள்நுழையவும்',
    signIn: 'உள்நுழைக',
  );

  static const te = ProfileStrings(
    myOrders: 'నా ఆర్డర్లు',
    wishlist: 'దాచిన వస్తువులు',
    addresses: 'డెలివరీ చిరునామాలు',
    language: 'భాష',
    help: 'సహాయం మరియు మద్దతు',
    about: 'BharatSe గురించి',
    switchToSeller: 'కళాకారుల వీక్షణకు మారండి',
    sellerModeSub: 'మీ కళను జాబితా చేసి భారతదేశంలోని కొనుగోలుదారులను చేరుకోండి',
    chooseLanguage: 'భాషను ఎంచుకోండి',
    guestName: 'అతిథి',
    guestSub:
        'ఆర్డర్లను చూడటానికి మరియు ఇష్టమైన వాటిని దాచుకోవడానికి సైన్ ఇన్ చేయండి',
    signIn: 'సైన్ ఇన్',
  );

  static const gu = ProfileStrings(
    myOrders: 'મારા ઓર્ડર',
    wishlist: 'સાચવેલી વસ્તુઓ',
    addresses: 'ડિલિવરી સરનામાં',
    language: 'ભાષા',
    help: 'મદદ અને સહાય',
    about: 'BharatSe વિશે',
    switchToSeller: 'કારીગર વ્યૂ પર જાઓ',
    sellerModeSub: 'તમારી કળા મૂકો અને સમગ્ર ભારતના ખરીદદારો સુધી પહોંચો',
    chooseLanguage: 'ભાષા પસંદ કરો',
    guestName: 'મહેમાન',
    guestSub: 'ઓર્ડર જોવા અને પસંદની વસ્તુઓ સાચવવા સાઇન ઇન કરો',
    signIn: 'સાઇન ઇન કરો',
  );

  static const kn = ProfileStrings(
    myOrders: 'ನನ್ನ ಆರ್ಡರ್‌ಗಳು',
    wishlist: 'ಉಳಿಸಿದ ವಸ್ತುಗಳು',
    addresses: 'ಡೆಲಿವರಿ ವಿಳಾಸಗಳು',
    language: 'ಭಾಷೆ',
    help: 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ',
    about: 'BharatSe ಕುರಿತು',
    switchToSeller: 'ಕುಶಲಕರ್ಮಿ ವೀಕ್ಷಣೆಗೆ ಬದಲಿಸಿ',
    sellerModeSub: 'ನಿಮ್ಮ ಕರಕುಶಲವನ್ನು ಪಟ್ಟಿ ಮಾಡಿ ಭಾರತದಾದ್ಯಂತ ಗ್ರಾಹಕರನ್ನು ತಲುಪಿ',
    chooseLanguage: 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
    guestName: 'ಅತಿಥಿ',
    guestSub:
        'ಆರ್ಡರ್‌ಗಳನ್ನು ನೋಡಲು ಮತ್ತು ಇಷ್ಟದ ವಸ್ತುಗಳನ್ನು ಉಳಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ',
    signIn: 'ಸೈನ್ ಇನ್',
  );

  static const od = ProfileStrings(
    myOrders: 'ମୋ ଅର୍ଡର',
    wishlist: 'ସଞ୍ଚିତ ଜିନିଷ',
    addresses: 'ଡେଲିଭରି ଠିକଣା',
    language: 'ଭାଷା',
    help: 'ସାହାଯ୍ୟ ଓ ସମର୍ଥନ',
    about: 'BharatSe ବିଷୟରେ',
    switchToSeller: 'କାରିଗର ଦୃଶ୍ୟକୁ ଯାଆନ୍ତୁ',
    sellerModeSub:
        'ଆପଣଙ୍କ ଶିଳ୍ପ ତାଲିକାଭୁକ୍ତ କରି ସାରା ଭାରତର ଗ୍ରାହକଙ୍କୁ ପହଞ୍ଚନ୍ତୁ',
    chooseLanguage: 'ଭାଷା ବାଛନ୍ତୁ',
    guestName: 'ଅତିଥି',
    guestSub: 'ଅର୍ଡର ଦେଖିବା ଓ ପସନ୍ଦ ସଞ୍ଚୟ କରିବା ପାଇଁ ସାଇନ୍ ଇନ୍ କରନ୍ତୁ',
    signIn: 'ସାଇନ୍ ଇନ୍ କରନ୍ତୁ',
  );

  static const pa = ProfileStrings(
    myOrders: 'ਮੇਰੇ ਆਰਡਰ',
    wishlist: 'ਸੰਭਾਲੀਆਂ ਚੀਜ਼ਾਂ',
    addresses: 'ਡਿਲਿਵਰੀ ਪਤੇ',
    language: 'ਭਾਸ਼ਾ',
    help: 'ਮਦਦ ਅਤੇ ਸਹਾਇਤਾ',
    about: 'BharatSe ਬਾਰੇ',
    switchToSeller: 'ਕਾਰੀਗਰ ਵਿਊ ਤੇ ਜਾਓ',
    sellerModeSub: 'ਆਪਣੀ ਕਲਾ ਸੂਚੀਬੱਧ ਕਰੋ ਅਤੇ ਭਾਰਤ ਭਰ ਦੇ ਖਰੀਦਦਾਰਾਂ ਤੱਕ ਪਹੁੰਚੋ',
    chooseLanguage: 'ਭਾਸ਼ਾ ਚੁਣੋ',
    guestName: 'ਮਹਿਮਾਨ',
    guestSub: 'ਆਰਡਰ ਵੇਖਣ ਅਤੇ ਪਸੰਦ ਦੀਆਂ ਚੀਜ਼ਾਂ ਸੰਭਾਲਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ',
    signIn: 'ਸਾਈਨ ਇਨ ਕਰੋ',
  );

  static ProfileStrings of(Lang lang) => switch (lang) {
    Lang.en => en,
    Lang.hi => hi,
    Lang.mr => mr,
    Lang.bn => bn,
    Lang.ta => ta,
    Lang.te => te,
    Lang.gu => gu,
    Lang.kn => kn,
    Lang.od => od,
    Lang.pa => pa,
  };
}
