
import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/scanner_screen.dart';
import 'package:mobile_app/screens/history/history_screen.dart';
import 'package:mobile_app/screens/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HistoryScreen(),
    const SizedBox(), // Placeholder for Scanner - logic handled in nav bar
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            // Open Scanner as full screen or modal
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScannerScreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        destinations: [
           NavigationDestination(
            icon: const Icon(Icons.history),
            label: l10n.history,
          ),
           NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner, size: 32),
            label: l10n.scan,
          ),
           NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
