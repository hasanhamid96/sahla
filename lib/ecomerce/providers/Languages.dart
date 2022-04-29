import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Languages extends ChangeNotifier {
  List<int> langClicked = [1, 0];
  bool onceChangeMain = false;
  Map<String, List<String>> translation = {
  'checkInternet': [
  'تحقق من اتصالك بالإنترنت!',
  'Check your internet connection !',
  ],
  'UpdateProfile': [
  'تحديث الملف',
  'Update Profile',
  ],
  'include': [
  'تضمن',
  'Include',
  ],
  'notInclude': [
  'لا يتضمن',
  'Not Include',
  ],
  'pendingService': [
  "الخدمات الحديثة",
  'Recent Services',
  ],
  'DoneService': [
  "الخدمات السابقة",
  'Past Services',
  ],
  'waitingForProcess': [
  "في انتظار أمر المعالجة ...",
  'waiting For Processing order...',
  ],
  'termsAndCondition': [
  'أحكام وشروط',
  'terms And Condition',
  ],
  'termAndCondition': [
  'أحكام وشروط',
  'Terms And Condition',
  ],
  'finalPrice': [
  'السعر الكلي',
  'Total price',
  ],
  'point': [
  'نقطة',
  'point',
  ], 'myPoints': [
  'نقاطي',
  'My Points',
  ],
  'priceAfterUsingpoints': [
  "السعر بعد استخدام النقاط",
  'price After Using points:',
  ],
  'pointsDeducted': [
  "عدد النقاط المخصومة",
  'the number of points deducted ',
  ],
  'priceInpoints': [
  "السعر بالنقاط",
  'price In points:',
  ],
  'requirePoints': [
  "تتطلب النقاط",
  'require Points',
  ], 'yourPoints': [
  "نقاطك",
  'your Points',
  ],
  'Rating Dialog': [
  "حوار التقييم",
  'Rating Dialog',
  ], 'don\'tHaveEnoughPoints': [
  "لا تملك نقاط كافية",
  'don\'t Have Enough Points',
  ], 'myPoints': [
  'نقاطي',
  'my points',
  ],
  'preOrder': [
  "ترتيب الجدول",
  'schedule order',
  ],
  'Submit': [
  'إرسال',
  'Submit',
  ],
  'pressToRate': [
  'اضغط على نجمة لتعيين تقييمك. أضف المزيد من الوصف هنا إذا كنت تريد. ',
  'Tap a star to set your rating. Add more description here if you want.',
  ],
  'sahla': [
  'تطبيق سهلة',
  'SAHLA App',
  ],'hello': [
  'اهلا ! أين تريد التصفح؟ ',
  'Hi, you ! Where do you want to browse?',
  ],
  'browsing': [
  "تصفح وتسوق لأكثر من 400 منتج.",
  'Browse and shop for more than 400 products.',
  ],
  'loc': [
  "كل ما عليك فعله هو الطلب والإضافة إلى عربة التسوق \ n وكتابة موقعك.",
  'All you have to do is order and add to cart\n and write your location.',
  ], 'howWe': [
  'من نحن',
  'How we',
  ],
  'speedingDeliver': [
  "ستتلقى طلبك في أقرب وقت ممكن.",
  'You will receive your order as soon as possible.',
  ],
  'pending': [
  'ريثما',
  'pending',
  ], 'categories': [
  'التصنيفات',
  'categories',
  ],
  'start': [
  'بدأت',
  'Started',
  ],
  'end': [
  "انتهى",
  'Ended',
  ],
  'addToFav': [
  'أضف إلى المفضلة',
  'add To Favorite',
  ],
  'myFavService': [
  "خدمتي المفضلة",
  'my Favorite Service ',
  ],
  'addOrder': [
  'اطلب الان!',
  'Order Now!',
  ],
  'getThisService': [
  "احصل على هذه الخدمة",
  'Get This Service',
  ], 'start': [
  'إبدأ الخدمة',
  'start service',
  ],
  'mostUsed': [
  'الأكثر استخداما',
  'Most Used'
  ],
  'myService': [
  "خدمتي",
  'My Service'
  ],
  'categories': [
    'التصنيفات',
  'categories'
  ],
  'backToMain': [
    'العودة إلى الرئيسية',
  'Back To Main',
  ],
  'back': [
    'رجوع',
  'Back',
  ],
  'caseProblem': [
  "مشكلة القضية (اختياري)",
  'Case Problem (optional)',
  ],
  'noInternetConeection': [
    "لا يوجد اتصال بالإنترنت ، الرجاء إعادة المحاولة!",
  'No internet connection , Please retry again!',
  ],
  'noInternetConeectionRetryButton': [
    "إعادة المحاولة",
  'Retry',
  ],
  'LanguageTitle': [
    'لغة ',
  'Language ',
  ],
  'SettingsTitle': [
    'إعدادات ',
  'Settings ',
  ],
  'signOut': [
    'خروج ',
  'Sign out ',
  ],
  'SignIn': [
    'تسجيل الدخول ',
  'Sign in ',
  ],
  'accountTitle': [
    'الحساب ',
  'Account ',
  ],
  'FavoriteTitle': [
    'مفضل ',
  'Favorite ',
  ],
  'FavoriteProd': [
    "المنتجات المفضلة",
  'Favorite Products ',
  ],
  'OrdersTitle': [
    "تاريخ الطلبات",
  'Orders history ',
  ],
  'oldOrdersTitle': [
    "الأوامر المنجزة",
  'Done orders',
  ],
  'searchThousndOfService': [
    "ابحث في آلاف الخدمات بنقرة واحدة",
  'Search thousands of Services in one click',
  ],
  'recentOrdersTitle': [
    'الطلبيات الأخيرة',
  'Recent orders',
  ],
  'MainSettings': [
    'الأساسية',
  'Main',
  ],
  'notification': [
    'إشعار ',
  'Notification ',
  ],
  'Languages': [
    'اللغات ',
  'Languages ',
  ],
  'nightMode': [
    'الوضع الليلي ',
  'Night mode ',
  ],
  'aboutUs': [
    'معلومات عنا',
  'About us',
  ],
  'signinTitle': [
    'اشتراك',
  'Sign up',
  ],
  'signinRequire': [
  'يتطلب تسجيل الدخول ',
  'Sign In Require',
  ],
  'registerTitle': [
    'يسجل',
  'Register',
  ],
  'emailTitle': [
    'بريد الالكتروني',
  'Email',
  ],
  'enterEmail': [
  'أدخل بريدك الإلكتروني',
  'Enter your Email',
  ],
  'passwordTitle': [
    'كلمه السر',
  'Password',
  ],
  'passwordTitleEnter': [
    'ادخل رقمك السري',
  'Enter your password',
  ],
  'phoneTitle': [
    'رقم الهاتف',
  'Phone number',
  ],
  'phoneTitleEnter': [
    'أدخل رقم هاتفك',
  'Enter your phone number',
  ],
  'rememberMe': [
    'تذكرنى',
  'Remember me',
  ],
  'DONThaveAccount': [
    "ليس لديك حساب؟",
  'Don\'t have account ?',
  ],
  'registerNow': [
    'سجل الان',
  'Register now',
  ],
  'allreadyHaveAccount': [
    "لديك حساب بالفعل؟",
  'Already have account ?',
  ],
  'username': [
    'اسم االمستخدم',
  'username',
  ],  'UserInformation': [
      'معلومات المستخدم',
  'User Information',
  ],
  'serviceName': [
    'اسم الخدمة',
  'service Name',
  ],
  'usernameEnter': [
    "أدخل الاسم الكامل",
  'Enter full name',
  ],
  'pleaseFillAllRecords': [
    'الرجاء تعبئة جميع الحقول',
  'Please fill all the fields',
  ],
  'pleaseFillEmail': [
    'Please enter a valid email address',
  'Please enter a valid email address',
  ],
  'youDidNotAddToCart': [
    "يبدو أنك لم تقم بإضافة أي عنصر حتى الآن ، دعنا نساعدك",
  'Looks like you have\'t add any item yet , let us help you',
  ],
  'startShopping': [
    "ابدأ التسوق",
  'Start Shopping',
  ],
  'shoppingBasket': [
    'سلة التسوق',
  'Shopping basket',
  ],
  'cartTitle': [
    'عربة التسوق',
  'Cart',
  ],
  'addressAndPaying': [
    "العنوان والدفع",
  'Address and Payment',
  ],
  'Confirmation': [
    'يتأكد',
  'Confirm',
  ],
  'continue': [
    'يكمل',
  'Continue',
  ],
  'shippingAddressTitle': [
    'عنوان الشحن',
  'Shipping Address',
  ],
  'noAddressSelectred': [
    "لم يتم تحديد أي عنوان",
  'No Address have been selected',
  ],
  'EditAddress': [
    "تحرير عنوان الشحن",
  'Edit shipping address',
  ],
  'PaymentTitle': [
    'الدفع',
  'Payment',
  ],
  'payOnDelivered': [
    'عند التسليم',
  'on delivery',
  ],
  'payUsingPoints': [
    "الدفع باستخدام النقاط",
  'pay Using Points',
  ],
  'pleaseSelectValidShippingAddress': [
    "الرجاء تحديد عنوان دفع وشحن صالح",
  'Please select valid payment & shipping address',
  ],
  'thersisNoAddressHaveBeenAdded': [
    "لم تتم إضافة أي عنوان ، يرجى إدخال عنوان شحن جديد",
  'No Address have been added , please insert new shipping address',
  ],
  'addNewShippingAddress': [
    'اضف عنوان شحن جديد',
  'Add new shipping address',
  ],
  'areOrKeyPlease': [
    'العنوان الكامل',
  'Full address',
  ],
  'conutryTitle': [
    'دولة',
  'Country',
  ],
  'cityTitle': [
    'مدينة',
  'City',
  ],
  'insert': [
    'يضيف',
  'Add',
  ],
  'only3allowed': [
    "مسموح بثلاثة عناوين فقط",
  'Only 3 addresses allowed',
  ],
  'nameTitle': [
    'اسم',
  'Name',
  ],
  'addressTitle': [
    "أقرب نقطة",
  'closest point',
  ],
  'phoneTitleAddress': [
    'هاتف',
  'Phone',
  ],
  'deleteTitle': [
    'حذف',
  'Delete',
  ],
  'chooseTitle': [
    'أختر',
  'choose',
  ],
  'searchTitle': [
    'بحث',
  'Search',
  ],
  'searchThousndOfProducts': [
    "ابحث في آلاف المنتجات بنقرة واحدة",
  'Search thousands of products in one click',
  ],
  'searchHistoryTitle': [
    "سجل البحث",
  'Search history',
  ],
  'youDidNotSearch': [
    "لم تبحث عن أي شيء حتى الآن - فلنبدأ الآن سنساعدك",

  'You didn\'t search for any thing yet - let\'s start now we will help you',
  ],
  'youDidNotSearchService': [
    "لم تبحث عن أي شيء حتى الآن - فلنبدأ الآن سنساعدك",
        'You didn\'t search for any thing yet - let\'s start now we will help you',
  ],
  'noSearchResult': [
    "لا توجد نتيجة بحث",
  'No Search Result',
  ],
  'researchAgain': [
    "البحث مرة أخرى من فضلك",
        'Search again please',
  ],
  'categoriesTitle': [
    'فئات',
  'Categories',
  ],
  'subcategoriesTitle': [
    "الفئات الفرعية",
  'sub Categories',
  ],
  'moreTitle': [
    'أكثر',
  'More',
  ],
  'shopInCategories': [
    "تسوق في الفئات",
  'Shop in Categories',
  ],
  'historyView': [
    'تاريخ',
  'History',
  ],
  'latestNews': [
    'آخر العروض',
  'Latest Offers',
  ],
  'discoverMore': [
    'يكتشف',
  'Discover',
  ],
  'addToCart': [
    'أضف إلى السلة',
  'Add To Cart',
  ],
  'haveBeenAddedToCart': [
    "تمت إضافة المنتج إلى سلة التسوق",
  'Product have been added to cart',
  ],
  'alreadyinTheCart': [
    "المنتج موجود بالفعل في عربة التسوق",
  'Product already in the cart',
  ],
  'PleaseSelectColor': [
    "الرجاء تحديد اللون والحجم",
        'Please select color and size',
  ],
  'PleaseSignInFirst': [
    "الرجاء تسجيل الدخول أولاً",
  'Please Sign in first',
  ],
  'similarProducts': [
    'شاهد المزيد',
  'See More',
  ],
  'ColorTitle': [
    ' لون',
  ': Color',
  ],
  'sizeTitle': [
    ': مقاس',
  ': Size',
  ],
  'main': [
    'الأساسية',
  'main',
  ],
  'remainsTitle': [
    'بقايا',
  'Remains',
  ],
  'outOfStock': [
    'إنتهى من المخزن',
  'Out of stock',
  ],
  'quantityTitle': [
    'كمية : ',
  'Quantity : ',
  ],
  'noFacoriteProducts': [
    "لم يتم اختيار أي منتج مفضل",
  'No Favorite product have been selected',
  ],
  'addMoreFavorite': [
    'أضف المزيد',
  'Add more',
  ],
  'clickToSeeMore': [
    "انقر لقراءة المزيد",
  'Click to Read more',
  ],
  'DescriptionTitle': [
    'وصف ',
  'Description ',
  ],
  'questionAndAnswers': [
    'التعليمات',
  'FAQ',
  ],
  'questionsTitle': [
    'أسئلة : ',
  'Questions : ',
  ],
  'orderDetails': [
    'تفاصيل الطلب',
  'Order History',
  ],
  'orderAddress': [
    'تاريخ الطلب',
  'Order History',
  ],
  'orderProducts': [
    'طلب بضاعة',
  'Order Items',
  ],
  'FollowOrder': [
    'ترتيب المسار',
  'Track Order',
  ],
  'moreDetails': [
    "رسالة من المسؤول",
  'Message from admin',
  ],
  'socialMedia': [
    'تابعنا',
  'Follow Us',
  ],
  'orderDoneConti': [
    "تم إجراء الطلب بنجاح ، يمكنك تتبع طلبك من شاشة الإعدادات",
  'Order have been made successfully , you can track your order from settings screen',
  ],
  'OK': [
    'نعم',
  'OK',
  ],
  'setting': [
    'إعدادت',
  'setting',
  ],
  'ConfirmeDate': [
    "تاريخ التأكيد",
  'Confirme Data',
  ],
  'CantApplyPromo': [
    "تأكيد البيانات",
  'Can\'t Apply the promocode',
  ],
  'tap': [
    'اضغط',
  'tap',
  ],
  'promocodeCorrect': [
    "تمت إضافة الرمز الترويجي",
  'promocode have been added',
  ],
  'wrongPromocode': [
    "كود ترويجي خاطئ",
  'wrong promocode',
  ],
  'promocode': [
    'رمز ترويجي',
  'Promocode',
  ],
  'price': [
    ': السعر',
  ': Price',
  ],
  'delivery': [
    'توصيل',
  'Delivery',
  ],
  'discount': [
    ': خصم',
  ': Discount',
  ],
  'total': [
    ': المجموع',
  ': Total',
  ],
  'confirmeTheBut': [
    "تأكيد العملية",
    'Confirme the process',
  ], 'termsAndConditionDESS': [
   '''الشروط و الاحكام
  1. تطبيق  سهلة على الهواتف الذكية هو مشروع  شبابي عراقي  ناشئ يعمل على ربط أصحاب المنازل و المنشآت التجارية بمزودي خدمات صيانة معتمدين في منطقتهم، عبر نظام حجوزات و مطابقة ذكية لتفاصيل العمل مع نظام تحديد المواقع عبر تقنية الـ GPS.
  2.تطبيق سهلة يجمع معلومات العميل الاتية: رقم الهاتف، إسم العميل و بريد العميل الإلكتروني (إختياري للعميل) و الموقع الجغرافي للعميل و ذلك لتأكيد حساب العميل و طلبه، و لا يقوم تطبيق سهلة  بمشاركة معلومات العميل لأهداف تجارية، و تستخدم المعلومات فقط لتقديم الخدمة بشكل أفضل.
  3. عند تسجيلك في التطبيق، فأنت توافق على تواصل فريق  تطبيق سهلة  للتواصل معك لتأكيد حسابك و طلباتك عند الحاجة، و مشاركة معلوماتك مع مزودي الخدمات  للقيام بالأعمال المطلوبة،

  4. ضمان العمل يقدم لك من طرف مزودي الخدمات في التطبيق، عبر تعهدهم بذلك عبر موافقتهم على شروط و أحكام التطبيق لمزودي الخدمات. فتطبيق سهلة  يعدك كذلك بإستقبال الشكاوي و مساعدة و دعم العميل للعمل بأتم شكل ممكن عبر المتابعة مع مزودي الخدمات و مراقبة أداءهم عبر نظام تقييم العملاء و مراجعاتهم،  منصة تطبيق سهلة غير مسؤولة عن أي عمل ينجم عنه إتلاف للمتلكات العامة، أو ممتلكات العمال أثناء قيامهم بتنفيذ العمل و يقر مزود الخدمات بمسئوليته الكاملة عن أي مساءلة أو تعويضات أو غيرها تترتب على ذلك.
  5. منصة تطبيق سهلة غير مسؤولة عن اي عمل مخالف للاعراف، الدين أو القانون  يصدر من مزودي أو عمال مزود الخدمات أثناء قيامهم بتنفيذ العمل و يقر مزود الخدمات بمسئوليته الكاملة عن أي مساءلة أو تعويضات أو غيرها تترتب على ذلك.

  6. مزود الخدمات يمثل جهة العمل الذي ينتمي لها عند زيارته للعمل، ولا يحق له التحدث بإسم منصة "سهلة"، بغير ماتنصه المنصه لمزود الخدمات عبر معايير و شروط العمل المتفق بها من الطرفان.

  7. الأسعار التقريبية في التطبيق هي قائمة الأسعار التقريبية حسب دراسة السوق، تحت ظروف العمل المثالية. ويقوم مزود الخدمات بتسعير العمل النهائي للعميل. في حال وجود إختلاف بالأسعار، نشجع العملاء على مراسة مركز سعادة العملاء بالتطبيق للتحقق من الأمر لمراقبة جودة و تسعيرة  و أداء مزود الخدمات. فالعميل هو صاحب القرار و شكوى العميل قد تعرض مزود الخدمات لإلغاء إشتراكه في التطبيق.
  8. جميع التصاميم و العلامة التجارية و وصف للخدمات و أي محتوى في التطبيق هو مملوك كليا لكيان تطبيق سهلة و مؤسسيه ، ولا يحق لأي مستخدم إستخدامها لأهداف شخصية أو تجارية.
  9. تخضع أحكام و شروط التطبيق للتغيير في اي وقت من قبل تطبيق سهلة و دون الحاجة لتقديم اي اشعار مسبق.",''',
    '''
  

1. Sahla application on smart phones is an emerging Iraqi youth project that works to connect home owners and commercial establishments with approved maintenance service providers in their area, through a smart reservation system and matching of work details with the GPS system via GPS technology.
2. Sahla application collects the following customer information: phone number, customer name, customer email (optional for the customer) and the geographical location of the customer in order to confirm the customer’s account and order, and the Sahla application does not share customer information for commercial purposes, and the information is used only to provide The service is better.
3. When you register in the application, you agree for the easy application team to communicate with you to confirm your account and requests when needed, and to share your information with service providers to carry out the required work,

4. The work guarantee is provided to you by the service providers in the application, by their undertaking to do so through their agreement to the terms and conditions of the application for the service providers. The Sahla application also promises you to receive complaints and help and support the customer to work as fully as possible by following up with service providers and monitoring their performance through the customer evaluation and reviews system. Work and the service provider acknowledges its full responsibility for any accountability, compensation, or others arising therefrom.
5. Easy application platform is not responsible for any action contrary to norms, religion or law issued by the service providers or workers of the service provider while they carry out the work, and the service provider acknowledges his full responsibility for any accountability, compensation, or others that result from that.

6. The service provider represents the employer to which he belongs when he visits work, and he is not entitled to speak on behalf of the “Sahla” platform, other than what the platform stipulates to the service provider through the standards and conditions of work agreed upon by the two parties.

7. Approximate prices in the application are the approximate price list according to market study, under ideal working conditions. The service provider rates the final work for the customer. In the event of a difference in prices, we encourage customers to contact the Customer Happiness Center in the application to verify the matter to monitor the quality, pricing and performance of the service provider. The customer is the decision maker, and the customer's complaint may expose the service provider to cancel his subscription to the application.
8. All designs, trademarks, description of services and any content in the application are wholly owned by the easy application entity and its founders, and no user has the right to use it for personal or commercial purposes.
9. The terms and conditions of the application are subject to change at any time by easy application and without the need to provide any prior notice.
    ''',
  ],
};
static int selectedLanguage = 0;
static String selectedLanguageStr = 'ar';
Future<void> setLangClicker() async {
  for (var i = 0; i < langClicked.length; i++) {
    langClicked[i] = 0;
  }
  notifyListeners();
}
  bool  once =true;
  readLanguageIndex() async {
    if(once){
      once =false;
      final prefs = await SharedPreferences.getInstance();
      final key = 'language';
      final keyStr = 'languageStr';
      final string = prefs.getInt(key);
      if (string == null) {
        selectedLanguage = 0;
        selectedLanguageStr = 'ar';
      } else {
        selectedLanguage = (prefs.getInt(key));
        selectedLanguageStr = (prefs.getString(keyStr));
      }
      readLanguageIndex2();
      notifyListeners();}
    }
    static readLanguageIndex2() async {
      final prefs = await SharedPreferences.getInstance();
      final key = 'language';
      final keyStr = 'languageStr';
      final string = prefs.getInt(key);
      if (string == null) {
        Languages.selectedLanguage = 0;
        Languages.selectedLanguageStr = 'ar';
      } else {
        Languages.selectedLanguage = (prefs.getInt(key));
        Languages.selectedLanguageStr = (prefs.getString(keyStr));
      }}
      saveLanguageIndex(int languageIndex) async {
        final prefs = await SharedPreferences.getInstance();
        final key = 'language';
        final keyStr = 'languageStr';
        var value = languageIndex;
        prefs.setInt(key, value);
        selectedLanguage = languageIndex;
        if (value == 0) {
          selectedLanguageStr = 'ar';
          prefs.setString(keyStr, 'ar');
        } else {
          selectedLanguageStr = 'en';
          prefs.setString(keyStr, 'en');
        }
        notifyListeners();}}