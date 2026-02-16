import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations ?? AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'app_name': 'Food Checker',
      
      // Login Screen
      'login_title': 'Login to continue',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'login': 'Login',
      'no_account': 'Don\'t have an account? Sign Up',
      'please_enter_email': 'Please enter email',
      'invalid_email': 'Invalid email',
      'password_min_chars': 'Password must be at least 6 chars',
      'login_failed': 'Login failed',
      
      // Sign Up Screen
      'create_account': 'Create Account',
      'sign_up_subtitle': 'Sign up to get started',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'sign_up': 'Sign Up',
      'please_enter_name': 'Please enter name',
      'min_6_chars': 'Min 6 chars',
      'passwords_not_match': 'Passwords do not match',
      'account_created': 'Account created! Please login.',
      'registration_failed': 'Registration failed',
      
      // Forgot Password Screen
      'reset_password': 'Reset Password',
      'reset_password_subtitle': 'Enter your email to receive a password reset link.',
      'send_reset_link': 'Send Reset Link',
      'reset_link_sent': 'Reset link sent! Check your email.',
      
      // Main Navigation
      'history': 'History',
      'scan': 'Scan',
      'settings': 'Settings',
      
      // History Screen
      'scan_history': 'Scan History',
      'product': 'Product',
      'scanned_on': 'Scanned on',
      
      // Settings Screen
      'language': 'Language',
      'logout': 'Logout',
      'english': 'English',
      'arabic': 'العربية',
      
      // Scanner Screen
      'enter_barcode': 'Enter Barcode',
      'camera_not_available': 'Camera not available on web',
      'enter_manually': 'Enter barcode manually',
      'barcode_label': 'Barcode',
      'barcode_hint': '3017620422003',
      'search_product': 'Search Product',
      'product_not_found': 'Product not found',
      
      // Common
      'error': 'Error',
      'cancel': 'Cancel',
      'ok': 'OK',
      'search': 'Search',
    },
    'ar': {
      // App
      'app_name': 'فاحص الطعام',
      
      // Login Screen
      'login_title': 'تسجيل الدخول للمتابعة',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login': 'تسجيل الدخول',
      'no_account': 'ليس لديك حساب؟ سجل الآن',
      'please_enter_email': 'الرجاء إدخال البريد الإلكتروني',
      'invalid_email': 'البريد الإلكتروني غير صالح',
      'password_min_chars': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'login_failed': 'فشل تسجيل الدخول',
      
      // Sign Up Screen
      'create_account': 'إنشاء حساب',
      'sign_up_subtitle': 'سجل للبدء',
      'full_name': 'الاسم الكامل',
      'confirm_password': 'تأكيد كلمة المرور',
      'sign_up': 'تسجيل',
      'please_enter_name': 'الرجاء إدخال الاسم',
      'min_6_chars': 'على الأقل 6 أحرف',
      'passwords_not_match': 'كلمات المرور غير متطابقة',
      'account_created': 'تم إنشاء الحساب! الرجاء تسجيل الدخول.',
      'registration_failed': 'فشل التسجيل',
      
      // Forgot Password Screen
      'reset_password': 'إعادة تعيين كلمة المرور',
      'reset_password_subtitle': 'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور.',
      'send_reset_link': 'إرسال رابط إعادة التعيين',
      'reset_link_sent': 'تم إرسال الرابط! تحقق من بريدك الإلكتروني.',
      
      // Main Navigation
      'history': 'السجل',
      'scan': 'مسح',
      'settings': 'الإعدادات',
      
      // History Screen
      'scan_history': 'سجل المسح',
      'product': 'منتج',
      'scanned_on': 'تم المسح في',
      
      // Settings Screen
      'language': 'اللغة',
      'logout': 'تسجيل الخروج',
      'english': 'English',
      'arabic': 'العربية',
      
      // Scanner Screen
      'enter_barcode': 'أدخل الباركود',
      'camera_not_available': 'الكاميرا غير متاحة على الويب',
      'enter_manually': 'أدخل الباركود يدويًا',
      'barcode_label': 'الباركود',
      'barcode_hint': '3017620422003',
      'search_product': 'بحث عن المنتج',
      'product_not_found': 'المنتج غير موجود',
      
      // Common
      'error': 'خطأ',
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'search': 'بحث',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Convenience getters
  String get appName => translate('app_name');
  String get loginTitle => translate('login_title');
  String get email => translate('email');
  String get password => translate('password');
  String get forgotPassword => translate('forgot_password');
  String get login => translate('login');
  String get noAccount => translate('no_account');
  String get createAccount => translate('create_account');
  String get signUpSubtitle => translate('sign_up_subtitle');
  String get fullName => translate('full_name');
  String get confirmPassword => translate('confirm_password');
  String get signUp => translate('sign_up');
  String get resetPassword => translate('reset_password');
  String get resetPasswordSubtitle => translate('reset_password_subtitle');
  String get sendResetLink => translate('send_reset_link');
  String get history => translate('history');
  String get scan => translate('scan');
  String get settings => translate('settings');
  String get scanHistory => translate('scan_history');
  String get product => translate('product');
  String get scannedOn => translate('scanned_on');
  String get language => translate('language');
  String get logout => translate('logout');
  String get english => translate('english');
  String get arabic => translate('arabic');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
