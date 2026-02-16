import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/locale_provider.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';
import 'package:mobile_app/screens/auth/signup_screen.dart';
import 'package:mobile_app/screens/main_screen.dart';
import 'package:mobile_app/utils/arabic_strings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  /* 
  // Try to initialize Firebase
  try {
    // If you have generated firebase_options.dart, verify it exists. 
    // Otherwise this might just fail or we use the default fallback.
    // For now, we wrap in try-catch to allow the app to run even if not fully configured yet.
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform, // Uncomment if you have options
    );
  } catch (e) {
    debugPrint("Firebase initialization failed (expected if not configured): $e");
    // Continue running app - AuthProvider handles fallback or errors
  }
  */

  runApp(const FoodCheckerApp());
}

class FoodCheckerApp extends StatelessWidget {
  const FoodCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<LocaleProvider, AuthProvider>(
        builder: (context, localeProvider, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: ArabicStrings.appName,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('ar'), // Arabic
              Locale('en'), // English
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: const Color(0xFF059669), // Emerald
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF059669),
                primary: const Color(0xFF059669),
                secondary: const Color(0xFF34D399),
                background: const Color(0xFFF8FAFC),
                surface: Colors.white,
              ),
              textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).apply(
                bodyColor: const Color(0xFF0F172A),
                displayColor: const Color(0xFF0F172A),
              ),
            ),
            // Define routes
            home: const LoginScreen(), // Start with Login
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}
