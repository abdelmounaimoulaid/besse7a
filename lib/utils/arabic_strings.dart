// Arabic strings utility for health insights module
// All user-facing text in Arabic as per requirements

class ArabicStrings {
  // Section title
  static const String healthOverview = 'نظرة صحية';

  // Overall labels
  static const String betterChoice = 'خيار أفضل';
  static const String okSometimes = 'مقبول أحيانًا';
  static const String limit = 'يُفضَّل تقليله';
  static const String unknown = 'غير معروف';

  // Score labels
  static const String nutriScore = 'نوتري-سكور';
  static const String basedOnQuality = 'بناءً على الجودة الغذائية';
  static const String nova = 'نوفا';

  // Nutrients
  static const String sugar = 'السكر';
  static const String salt = 'الملح';
  static const String saturatedFat = 'الدهون المشبعة';
  static const String fiber = 'الألياف';
  static const String protein = 'البروتين';
  static const String energy = 'الطاقة';
  static const String fat = 'الدهون';
  static const String carbohydrates = 'الكربوهيدرات';

  // Warnings
  static const String allergens = 'مسببات الحساسية';
  static const String traces = 'آثار محتملة';
  static const String additives = 'مضافات';

  // Status words
  static const String low = 'منخفض';
  static const String moderate = 'متوسط';
  static const String high = 'مرتفع';

  // Per serving label
  static const String perServing = 'لكل حصة';

  // Home Screen
  static const String appName = 'بصحة';
  static const String appSubtitle = 'اتخذ خيارات صحية في ثوانٍ';
  static const String scanProduct = 'مسح المنتج';
  static const String worksWith = 'يعمل مع المنتجات المغربية والعالمية';

  // Scanner Screen
  static const String enterBarcode = 'أدخل الباركود';
  static const String cameraNotAvailable = 'الكاميرا غير متوفرة على الويب';
  static const String enterManually = 'أدخل الباركود يدويًا للاختبار';
  static const String barcodeLabel = 'الباركود';
  static const String barcodeHint = 'أدخل الباركود (مثلاً: 3017620422003)';
  static const String searchProduct = 'البحث عن المنتج';
  static const String alignBarcode = 'قم بمحاذاة الباركود داخل الإطار';
  static const String productNotFound = 'المنتج غير موجود أو حدث خطأ';

  // Product Result Screen
  static const String ingredients = 'المكونات';
  static const String scanAnother = 'مسح منتج آخر';
  static const String loading = 'جاري التحميل...';
  static const String nutritionFacts = 'حقائق غذائية (لكل 100 جرام)';
  static const String betterAlternatives = 'بدائل أفضل';
  static const String noAlternatives = 'لم يتم العثور على بدائل';

  // Product Status
  static const String statusGood = 'جيد';
  static const String statusAverage = 'متوسط';
  static const String statusBad = 'سيئ';
  
  // Error Messages & Fallbacks
  static const String unknownProduct = 'منتج غير معروف';
  static const String unknownBrand = 'علامة تجارية غير معروفة';
  static const String noIngredientsListed = 'لم يتم إدراج المكونات';
  static const String productNotFoundInDatabase = 'المنتج غير موجود في قاعدة البيانات';
  static const String failedToLoadProduct = 'فشل تحميل المنتج';
  static const String failedToLoadAlternatives = 'فشل تحميل البدائل';
  static const String errorOccurred = 'حدث خطأ';
  
  // Total amounts (based on product weight)
  static const String totalInPackage = 'المجموع في العبوة';
  static const String packageWeight = 'وزن العبوة';
  static const String totalAmounts = 'الكميات الإجمالية';

  // Allergen Translations
  static const Map<String, String> allergenTranslations = {
    'en:milk': 'حليب',
    'milk': 'حليب',
    'en:gluten': 'غلوتين',
    'gluten': 'غلوتين',
    'en:eggs': 'بيض',
    'eggs': 'بيض',
    'en:soybeans': 'فول الصويا',
    'soybeans': 'فول الصويا',
    'en:nuts': 'مكسرات',
    'nuts': 'مكسرات',
    'en:fish': 'سمك',
    'fish': 'سمك',
    'en:mustard': 'خردل',
    'mustard': 'خردل',
    'en:celery': 'كرفس',
    'celery': 'كرفس',
    'en:peanuts': 'فول سوداني',
    'peanuts': 'فول سوداني',
    'en:sesame-seeds': 'بذور السمسم',
    'sesame': 'سمسم',
    'en:sulphur-dioxide-and-sulphites': 'ثاني أكسيد الكبريت',
    'sulphites': 'كبريتات',
    'en:lupin': 'ترمس',
    'lupin': 'ترمس',
    'en:molluscs': 'رخويات',
    'molluscs': 'رخويات',
    'en:crustaceans': 'قشريات',
    'crustaceans': 'قشريات',
    'en:wheat': 'قمح',
    'wheat': 'قمح',
  };
}
