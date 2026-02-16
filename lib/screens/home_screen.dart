
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/scanner_screen.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Color(0xFF059669),
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Colors.white,
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  
                  const Gap(24),
                  
                  Text(
                    ArabicStrings.appName,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn().moveY(begin: 20, end: 0, delay: 200.ms),
                  
                  const Gap(8),
                  
                  Text(
                    ArabicStrings.appSubtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ).animate().fadeIn().moveY(begin: 20, end: 0, delay: 300.ms),
                  
                  const Spacer(),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.center_focus_strong),
                          const Gap(12),
                          Text(
                            ArabicStrings.scanProduct,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().moveY(begin: 30, end: 0, delay: 400.ms),
                  
                  const Gap(16),
                  
                  Text(
                    ArabicStrings.worksWith,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                  
                  const Gap(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
