import 'lang.dart';

/// Every user-facing string in the app.
///
/// Deliberately a class of fields rather than a map, so a missing translation
/// is a compile error instead of a blank label discovered on stage.
class AppStrings {
  const AppStrings({
    required this.tagline,
    required this.navHome,
    required this.navExplore,
    required this.navOrders,
    required this.navProfile,
    required this.searchHint,
    required this.seeAll,
    required this.heroLine1,
    required this.heroLine2,
    required this.heroLine3,
    required this.heroBody,
    required this.heroCta,
    required this.shopByState,
    required this.curatedForYou,
    required this.byArtisan,
    required this.exploreTitle,
    required this.exploreSubtitle,
    required this.browseByCraft,
    required this.allStates,
    required this.supportTitle,
    required this.supportBody,
    required this.learnMore,
    required this.craftsCount,
    required this.profileTitle,
    required this.guestName,
    required this.guestSub,
    required this.signIn,
    required this.myOrders,
    required this.wishlist,
    required this.addresses,
    required this.language,
    required this.help,
    required this.about,
    required this.switchToSeller,
    required this.sellerModeSub,
    required this.chooseLanguage,
    required this.addToCart,
    required this.buyNow,
    required this.aboutThisCraft,
    required this.craftPassport,
    required this.passportVerified,
    required this.material,
    required this.technique,
    required this.origin,
    required this.madeIn,
    required this.hoursOfWork,
    required this.artisanNote,
    required this.deliveryBy,
    required this.inStock,
    required this.emptyOrders,
    required this.emptyWishlist,
    required this.offlineNotice,
    required this.offlineNoticeWithCount,
    required this.syncing,
    required this.allSynced,
    required this.savedOnPhone,
    required this.newArrivals,
    required this.trustTitle,
    required this.trustBody,
    required this.cart,
    required this.cartEmpty,
    required this.cartEmptyBody,
    required this.subtotal,
    required this.delivery,
    required this.freeDelivery,
    required this.total,
    required this.checkout,
    required this.remove,
    required this.tapAState,
    required this.craftsFrom,
    required this.theCraft,
    required this.artisansHere,
    required this.startShopping,
    required this.qty,
    required this.addPhotos,
    required this.addPhotosSub,
    required this.addPhoto,
    required this.stepOf,
    required this.holdToDescribe,
    required this.inYourLanguage,
    required this.listening,
    required this.releaseToFinish,
    required this.preparing,
    required this.aiSuggestions,
    required this.enhancedImages,
    required this.beforeLabel,
    required this.afterLabel,
    required this.takePhotoAction,
    required this.chooseFromGallery,
    required this.photoSource,
    required this.mainPhoto,
    required this.tapToSetMain,
    required this.improvingPhoto,
    required this.improvePhoto,
    required this.couldNotImprove,
    required this.improvedOffline,
    required this.productStory,
    required this.suggestedPrice,
    required this.priceIsFair,
    required this.priceRange,
    required this.neverBelowWage,
    required this.lowestPrice,
    required this.productDetails,
    required this.hoursTaken,
    required this.publishToMarket,
    required this.saveOnPhoneCta,
    required this.hoursUnit,
    required this.listen,
    required this.edit,
    required this.couldNotGenerate,
    required this.tryAgain,
    required this.micNeeded,
    required this.noteTooShort,
    required this.myProducts,
    required this.addProduct,
    required this.noProductsYet,
    required this.noProductsBody,
    required this.waitingToSync,
    required this.published,
    required this.draft,
    required this.categoryLabel,
    required this.verifyTitle,
    required this.verifySubtitle,
    required this.verifyWhy,
    required this.verifyUpload,
    required this.verifyRetake,
    required this.verifySubmit,
    required this.verifySubmitting,
    required this.verifyPendingTitle,
    required this.verifyPendingBody,
    required this.verifyApprovedTitle,
    required this.verifyFailed,
    required this.verifyDocumentHint,
    required this.verifyPrivacy,
    required this.checkAgain,
    required this.landingTagline,
    required this.continueAsBuyer,
    required this.continueAsSeller,
    required this.buyerBlurb,
    required this.sellerBlurb,
    required this.signInTitle,
    required this.signUpTitle,
    required this.emailLabel,
    required this.passwordLabel,
    required this.nameLabel,
    required this.continueWithGoogle,
    required this.orDivider,
    required this.haveAccount,
    required this.noAccount,
    required this.createAccount,
    required this.signInAction,
    required this.signingIn,
    required this.emailRequired,
    required this.passwordTooShort,
    required this.signOut,
    required this.changeRole,
  });

  final String tagline;

  // navigation
  final String navHome;
  final String navExplore;
  final String navOrders;
  final String navProfile;

  // chrome
  final String searchHint;
  final String seeAll;

  // home
  final String heroLine1;
  final String heroLine2;
  final String heroLine3;
  final String heroBody;
  final String heroCta;
  final String shopByState;
  final String curatedForYou;
  final String byArtisan;

  // explore
  final String exploreTitle;
  final String exploreSubtitle;
  final String browseByCraft;
  final String allStates;
  final String supportTitle;
  final String supportBody;
  final String learnMore;
  final String craftsCount;

  // profile
  final String profileTitle;
  final String guestName;
  final String guestSub;
  final String signIn;
  final String myOrders;
  final String wishlist;
  final String addresses;
  final String language;
  final String help;
  final String about;
  final String switchToSeller;
  final String sellerModeSub;
  final String chooseLanguage;

  // product
  final String addToCart;
  final String buyNow;
  final String aboutThisCraft;
  final String craftPassport;
  final String passportVerified;
  final String material;
  final String technique;
  final String origin;
  final String madeIn;
  final String hoursOfWork;
  final String artisanNote;
  final String deliveryBy;
  final String inStock;

  // empty states
  final String emptyOrders;
  final String emptyWishlist;

  // connectivity
  final String offlineNotice;
  final String offlineNoticeWithCount;
  final String syncing;
  final String allSynced;
  final String savedOnPhone;

  // home extras
  final String newArrivals;
  final String trustTitle;
  final String trustBody;

  // cart and state
  final String cart;
  final String cartEmpty;
  final String cartEmptyBody;
  final String subtotal;
  final String delivery;
  final String freeDelivery;
  final String total;
  final String checkout;
  final String remove;
  final String tapAState;
  final String craftsFrom;
  final String theCraft;
  final String artisansHere;
  final String startShopping;
  final String qty;

  // seller
  final String addPhotos;
  final String addPhotosSub;
  final String addPhoto;
  final String stepOf;
  final String holdToDescribe;
  final String inYourLanguage;
  final String listening;
  final String releaseToFinish;
  final String preparing;
  final String aiSuggestions;
  final String enhancedImages;
  final String beforeLabel;
  final String afterLabel;
  final String takePhotoAction;
  final String chooseFromGallery;
  final String photoSource;
  final String mainPhoto;
  final String tapToSetMain;
  final String improvingPhoto;
  final String improvePhoto;
  final String couldNotImprove;
  final String improvedOffline;
  final String productStory;
  final String suggestedPrice;
  final String priceIsFair;
  final String priceRange;
  final String neverBelowWage;
  final String lowestPrice;
  final String productDetails;
  final String hoursTaken;
  final String publishToMarket;
  final String saveOnPhoneCta;
  final String hoursUnit;
  final String listen;
  final String edit;
  final String couldNotGenerate;
  final String tryAgain;
  final String micNeeded;
  final String noteTooShort;
  final String myProducts;
  final String addProduct;
  final String noProductsYet;
  final String noProductsBody;
  final String waitingToSync;
  final String published;
  final String draft;
  final String categoryLabel;

  // verification
  final String verifyTitle;
  final String verifySubtitle;
  final String verifyWhy;
  final String verifyUpload;
  final String verifyRetake;
  final String verifySubmit;
  final String verifySubmitting;
  final String verifyPendingTitle;
  final String verifyPendingBody;
  final String verifyApprovedTitle;
  final String verifyFailed;
  final String verifyDocumentHint;
  final String verifyPrivacy;
  final String checkAgain;

  // landing and auth
  final String landingTagline;
  final String continueAsBuyer;
  final String continueAsSeller;
  final String buyerBlurb;
  final String sellerBlurb;
  final String signInTitle;
  final String signUpTitle;
  final String emailLabel;
  final String passwordLabel;
  final String nameLabel;
  final String continueWithGoogle;
  final String orDivider;
  final String haveAccount;
  final String noAccount;
  final String createAccount;
  final String signInAction;
  final String signingIn;
  final String emailRequired;
  final String passwordTooShort;
  final String signOut;
  final String changeRole;

  static const AppStrings en = AppStrings(
    tagline: 'From the people of Bharat, for Bharat',
    navHome: 'Home',
    navExplore: 'Explore',
    navOrders: 'Orders',
    navProfile: 'Profile',
    searchHint: 'Search crafts, states, artisans',
    seeAll: 'See all',
    heroLine1: 'Made by hand.',
    heroLine2: 'Made with heart.',
    heroLine3: 'Made in Bharat.',
    heroBody:
        'Discover authentic handicrafts made by artisans and weavers from every corner of India.',
    heroCta: 'Explore crafts',
    shopByState: 'Shop by state',
    curatedForYou: 'Chosen for you',
    byArtisan: 'By',
    exploreTitle: 'Explore',
    exploreSubtitle:
        'Authentic crafts and the stories behind them, from every corner of India.',
    browseByCraft: 'Browse by craft',
    allStates: 'States and their crafts',
    supportTitle: 'Support local artisans',
    supportBody:
        'Every purchase empowers artisans and preserves India’s living heritage.',
    learnMore: 'Learn more',
    craftsCount: 'crafts',
    profileTitle: 'Profile',
    guestName: 'Guest',
    guestSub: 'Sign in to track orders and save favourites',
    signIn: 'Sign in',
    myOrders: 'My orders',
    wishlist: 'Saved items',
    addresses: 'Delivery addresses',
    language: 'Language',
    help: 'Help and support',
    about: 'About BharatSe',
    switchToSeller: 'Switch to artisan view',
    sellerModeSub: 'List your craft and reach buyers across India',
    chooseLanguage: 'Choose language',
    addToCart: 'Add to cart',
    buyNow: 'Buy now',
    aboutThisCraft: 'About this craft',
    craftPassport: 'Craft Passport',
    passportVerified: 'Provenance verified, not claimed',
    material: 'Material',
    technique: 'Technique',
    origin: 'Origin',
    madeIn: 'Made in',
    hoursOfWork: 'Hours of work',
    artisanNote: 'From the maker',
    deliveryBy: 'Delivery by',
    inStock: 'In stock',
    emptyOrders: 'No orders yet',
    emptyWishlist: 'Nothing saved yet',
    offlineNotice: 'No internet. Keep going, nothing is lost.',
    offlineNoticeWithCount: 'No internet. {n} saved on your phone.',
    syncing: 'Syncing… {n} left',
    allSynced: 'Everything is synced',
    savedOnPhone: 'Saved on phone',
    newArrivals: 'New from the clusters',
    trustTitle: 'Every piece carries a Craft Passport',
    trustBody:
        'Scan the tag on the product and see who made it, where, and how long '
        'it took. Provenance verified, not claimed.',
    cart: 'Cart',
    cartEmpty: 'Your cart is empty',
    cartEmptyBody: 'Crafts you add will appear here.',
    subtotal: 'Subtotal',
    delivery: 'Delivery',
    freeDelivery: 'Free',
    total: 'Total',
    checkout: 'Proceed to checkout',
    remove: 'Remove',
    tapAState: 'Tap a state to see its crafts',
    craftsFrom: 'Crafts from',
    theCraft: 'The craft',
    artisansHere: 'artisans here',
    startShopping: 'Start exploring',
    qty: 'Qty',
    addPhotos: 'Add photo or video',
    addPhotosSub: 'Clear pictures of what you made',
    addPhoto: 'Add photo',
    stepOf: 'Step',
    holdToDescribe: 'Hold and tell us about your product',
    inYourLanguage: 'In your own language',
    listening: 'Listening. Keep talking.',
    releaseToFinish: 'Let go when you are done',
    preparing: 'Writing your listing',
    aiSuggestions: 'Prepared for you',
    enhancedImages: 'Improved pictures',
    beforeLabel: 'Before',
    afterLabel: 'After',
    takePhotoAction: 'Take a photo',
    chooseFromGallery: 'Choose from gallery',
    photoSource: 'Add a picture',
    mainPhoto: 'Main',
    tapToSetMain: 'Tap a picture to make it the main one',
    improvingPhoto: 'Making your picture better',
    improvePhoto: 'Improve picture',
    couldNotImprove: 'Could not improve the picture',
    improvedOffline: 'Improved on this phone',
    productStory: 'The story of this piece',
    suggestedPrice: 'Suggested price',
    priceIsFair: 'Fair for today\'s market',
    priceRange: 'Between',
    neverBelowWage: 'Never less than your own work is worth.',
    lowestPrice: 'Lowest',
    productDetails: 'Details',
    hoursTaken: 'Hours it took',
    publishToMarket: 'Send to market',
    saveOnPhoneCta: 'Save on this phone',
    hoursUnit: 'hours',
    listen: 'Listen',
    edit: 'Change',
    couldNotGenerate: 'Could not write the listing just now',
    tryAgain: 'Try again',
    micNeeded: 'The microphone is needed to hear you',
    noteTooShort: 'That was too short. Hold the button and speak.',
    myProducts: 'My products',
    addProduct: 'Add a product',
    noProductsYet: 'Nothing listed yet',
    noProductsBody: 'Take a photo, say what it is, and it goes on sale.',
    waitingToSync: 'Waiting for signal',
    published: 'On sale',
    draft: 'Draft',
    categoryLabel: 'Category',
    verifyTitle: 'Verify who you are',
    verifySubtitle: 'One time, so buyers know your work is really yours',
    verifyWhy: 'Every product you list carries your name. We check identity once so nobody else can list under it.',
    verifyUpload: 'Upload Aadhaar or ID',
    verifyRetake: 'Choose a different photo',
    verifySubmit: 'Send for review',
    verifySubmitting: 'Sending',
    verifyPendingTitle: 'Sent for review',
    verifyPendingBody: 'Someone from the ministry will check this. It usually takes a day. You can close the app.',
    verifyApprovedTitle: 'You are verified',
    verifyFailed: 'Could not send it just now',
    verifyDocumentHint: 'A clear photo of the whole card, or a PDF',
    verifyPrivacy: 'Your document is stored privately and is only seen by the reviewing officer.',
    checkAgain: 'Check again',
    landingTagline: 'Handmade, from the people of Bharat',
    continueAsBuyer: 'I want to buy',
    continueAsSeller: 'I make things',
    buyerBlurb: 'Browse crafts from every corner of India',
    sellerBlurb: 'List your work and reach buyers everywhere',
    signInTitle: 'Sign in',
    signUpTitle: 'Create your account',
    emailLabel: 'Email',
    passwordLabel: 'Password',
    nameLabel: 'Your name',
    continueWithGoogle: 'Continue with Google',
    orDivider: 'or',
    haveAccount: 'Already have an account?',
    noAccount: 'New here?',
    createAccount: 'Create one',
    signInAction: 'Sign in',
    signingIn: 'Signing you in',
    emailRequired: 'Enter your email and password',
    passwordTooShort: 'Use at least six characters',
    signOut: 'Sign out',
    changeRole: 'Switch account type',
  );

  static const AppStrings hi = AppStrings(
    tagline: 'भारत के लोगों से, भारत के लिए',
    navHome: 'होम',
    navExplore: 'खोजें',
    navOrders: 'ऑर्डर',
    navProfile: 'प्रोफ़ाइल',
    searchHint: 'शिल्प, राज्य, कारीगर खोजें',
    seeAll: 'सभी देखें',
    heroLine1: 'हाथ से बना.',
    heroLine2: 'दिल से बना.',
    heroLine3: 'भारत से.',
    heroBody:
        'भारत के हर कोने के कारीगरों और बुनकरों द्वारा बनाए गए असली हस्तशिल्प को खोजें।',
    heroCta: 'शिल्प खोजें',
    shopByState: 'राज्य के अनुसार खोजें',
    curatedForYou: 'आपके लिए चुना गया',
    byArtisan: 'द्वारा',
    exploreTitle: 'खोजें',
    exploreSubtitle: 'भारत के हर कोने से असली शिल्प और उनकी कहानियाँ।',
    browseByCraft: 'शिल्प के अनुसार देखें',
    allStates: 'राज्य और उनके शिल्प',
    supportTitle: 'कारीगरों का साथ दें',
    supportBody:
        'हर खरीद कारीगरों को मज़बूत बनाती है और भारत की विरासत को बचाती है।',
    learnMore: 'और जानें',
    craftsCount: 'शिल्प',
    profileTitle: 'प्रोफ़ाइल',
    guestName: 'अतिथि',
    guestSub: 'ऑर्डर देखने और पसंद सहेजने के लिए साइन इन करें',
    signIn: 'साइन इन करें',
    myOrders: 'मेरे ऑर्डर',
    wishlist: 'सहेजी गई चीज़ें',
    addresses: 'डिलीवरी पते',
    language: 'भाषा',
    help: 'मदद',
    about: 'BharatSe के बारे में',
    switchToSeller: 'कारीगर व्यू पर जाएँ',
    sellerModeSub: 'अपना शिल्प डालें और पूरे भारत तक पहुँचें',
    chooseLanguage: 'भाषा चुनें',
    addToCart: 'कार्ट में डालें',
    buyNow: 'अभी खरीदें',
    aboutThisCraft: 'इस शिल्प के बारे में',
    craftPassport: 'शिल्प पासपोर्ट',
    passportVerified: 'पहचान जाँची गई है, सिर्फ़ दावा नहीं',
    material: 'कच्चा माल',
    technique: 'तकनीक',
    origin: 'मूल',
    madeIn: 'कहाँ बना',
    hoursOfWork: 'कितने घंटे लगे',
    artisanNote: 'कारीगर की ओर से',
    deliveryBy: 'डिलीवरी',
    inStock: 'उपलब्ध है',
    emptyOrders: 'अभी कोई ऑर्डर नहीं',
    emptyWishlist: 'अभी कुछ सहेजा नहीं गया',
    offlineNotice: 'इंटरनेट नहीं है। काम करते रहिए, कुछ नहीं खोएगा।',
    offlineNoticeWithCount:
        'इंटरनेट नहीं है। {n} चीज़ें फ़ोन में सुरक्षित हैं।',
    syncing: 'सिंक हो रहा है… {n} बची हैं',
    allSynced: 'सब कुछ सिंक हो गया',
    savedOnPhone: 'फ़ोन में सुरक्षित',
    newArrivals: 'क्लस्टर से नया',
    trustTitle: 'हर चीज़ के साथ शिल्प पासपोर्ट',
    trustBody:
        'सामान पर लगा टैग स्कैन कीजिए और देखिए किसने बनाया, कहाँ बनाया, और '
        'कितना समय लगा। पहचान जाँची गई है, सिर्फ़ दावा नहीं।',
    cart: 'कार्ट',
    cartEmpty: 'आपका कार्ट खाली है',
    cartEmptyBody: 'आप जो शिल्प डालेंगे वे यहाँ दिखेंगे।',
    subtotal: 'कुल सामान',
    delivery: 'डिलीवरी',
    freeDelivery: 'मुफ़्त',
    total: 'कुल',
    checkout: 'आगे बढ़ें',
    remove: 'हटाएँ',
    tapAState: 'शिल्प देखने के लिए राज्य पर टैप करें',
    craftsFrom: 'यहाँ के शिल्प',
    theCraft: 'यह शिल्प',
    artisansHere: 'कारीगर यहाँ',
    startShopping: 'खोजना शुरू करें',
    qty: 'संख्या',
    addPhotos: 'फ़ोटो या वीडियो जोड़ें',
    addPhotosSub: 'अपने सामान की साफ़ तस्वीरें लगाइए',
    addPhoto: 'फ़ोटो जोड़ें',
    stepOf: 'चरण',
    holdToDescribe: 'दबाकर अपने सामान के बारे में बताइए',
    inYourLanguage: 'अपनी भाषा में',
    listening: 'सुन रहे हैं। बोलते रहिए।',
    releaseToFinish: 'हो जाए तो छोड़ दीजिए',
    preparing: 'आपकी लिस्टिंग बन रही है',
    aiSuggestions: 'आपके लिए तैयार किया गया',
    enhancedImages: 'बेहतर की गई तस्वीरें',
    beforeLabel: 'पहले',
    afterLabel: 'बाद में',
    takePhotoAction: 'फ़ोटो खींचिए',
    chooseFromGallery: 'गैलरी से चुनिए',
    photoSource: 'तस्वीर जोड़िए',
    mainPhoto: 'मुख्य',
    tapToSetMain: 'मुख्य बनाने के लिए तस्वीर पर टैप कीजिए',
    improvingPhoto: 'आपकी तस्वीर बेहतर की जा रही है',
    improvePhoto: 'तस्वीर बेहतर करें',
    couldNotImprove: 'तस्वीर बेहतर नहीं हो सकी',
    improvedOffline: 'इसी फ़ोन पर बेहतर की गई',
    productStory: 'सामान की कहानी',
    suggestedPrice: 'सुझाया गया दाम',
    priceIsFair: 'आज के बाज़ार के हिसाब से सही',
    priceRange: 'के बीच',
    neverBelowWage: 'आपकी मेहनत से कम दाम कभी नहीं।',
    lowestPrice: 'सबसे कम',
    productDetails: 'सामान का ब्यौरा',
    hoursTaken: 'कितने घंटे लगे',
    publishToMarket: 'बाज़ार में भेजें',
    saveOnPhoneCta: 'इसी फ़ोन में सुरक्षित करें',
    hoursUnit: 'घंटे',
    listen: 'सुनें',
    edit: 'बदलें',
    couldNotGenerate: 'अभी लिस्टिंग नहीं बन पाई',
    tryAgain: 'फिर कोशिश करें',
    micNeeded: 'आपको सुनने के लिए माइक चाहिए',
    noteTooShort: 'बहुत छोटा था। बटन दबाकर बोलिए।',
    myProducts: 'मेरा सामान',
    addProduct: 'नया सामान जोड़ें',
    noProductsYet: 'अभी कुछ नहीं डाला',
    noProductsBody: 'फ़ोटो लीजिए, बताइए क्या है, और वह बिकने लगेगा।',
    waitingToSync: 'सिग्नल का इंतज़ार',
    published: 'बिक्री पर',
    draft: 'अधूरा',
    categoryLabel: 'श्रेणी',
    verifyTitle: 'अपनी पहचान बताइए',
    verifySubtitle: 'एक बार, ताकि खरीदार जानें कि काम वाकई आपका है',
    verifyWhy: 'आप जो भी सामान डालेंगी उस पर आपका नाम रहेगा। पहचान एक बार जाँच लेते हैं ताकि कोई और आपके नाम से न बेच सके।',
    verifyUpload: 'आधार या पहचान पत्र डालें',
    verifyRetake: 'दूसरी फ़ोटो चुनें',
    verifySubmit: 'जाँच के लिए भेजें',
    verifySubmitting: 'भेजा जा रहा है',
    verifyPendingTitle: 'जाँच के लिए भेज दिया',
    verifyPendingBody: 'मंत्रालय से कोई इसे देखेगा। आमतौर पर एक दिन लगता है। आप ऐप बंद कर सकती हैं।',
    verifyApprovedTitle: 'आपकी पहचान जाँच ली गई',
    verifyFailed: 'अभी भेज नहीं पाए',
    verifyDocumentHint: 'पूरे कार्ड की साफ़ फ़ोटो, या PDF',
    verifyPrivacy: 'आपका दस्तावेज़ सुरक्षित रखा जाता है और सिर्फ़ जाँच करने वाले अधिकारी को दिखता है।',
    checkAgain: 'फिर देखें',
    landingTagline: 'हाथ से बना, भारत के लोगों से',
    continueAsBuyer: 'मुझे खरीदना है',
    continueAsSeller: 'मैं बनाती हूँ',
    buyerBlurb: 'भारत के हर कोने के शिल्प देखिए',
    sellerBlurb: 'अपना काम डालिए और हर जगह तक पहुँचिए',
    signInTitle: 'साइन इन करें',
    signUpTitle: 'अपना खाता बनाइए',
    emailLabel: 'ईमेल',
    passwordLabel: 'पासवर्ड',
    nameLabel: 'आपका नाम',
    continueWithGoogle: 'Google से आगे बढ़ें',
    orDivider: 'या',
    haveAccount: 'पहले से खाता है?',
    noAccount: 'नए हैं?',
    createAccount: 'खाता बनाइए',
    signInAction: 'साइन इन करें',
    signingIn: 'साइन इन हो रहा है',
    emailRequired: 'ईमेल और पासवर्ड डालिए',
    passwordTooShort: 'कम से कम छह अक्षर रखिए',
    signOut: 'साइन आउट',
    changeRole: 'खाते का प्रकार बदलें',
  );

  /// English is the reviewed fallback while additional UI translations are
  /// added. Data content still uses the selected language when available.
  static AppStrings of(Lang lang) => switch (lang) {
    Lang.hi => hi,
    _ => en,
  };
}
