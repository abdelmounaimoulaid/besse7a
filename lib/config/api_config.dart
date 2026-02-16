import 'package:flutter/foundation.dart';

class ApiConfig {
  // ---------------------------------------------------------------------------
  // IMPORTANT: UPDATE THIS IP ADDRESS FOR REAL DEVICE TESTING
  // ---------------------------------------------------------------------------
  // If you are using a real Android device, replace '10.0.2.2' with your 
  // computer's local IP address (e.g., '192.168.1.10').
  // Find it by running `ipconfig getifaddr en0` on your Mac.
  // ---------------------------------------------------------------------------
  static const String _androidBaseUrl = 'http://10.0.2.2:8000/api'; 
  
  static const String _iosBaseUrl = 'http://127.0.0.1:8000/api';
  static const String _webBaseUrl = 'http://localhost:8000/api';

  static String get baseUrl {
    if (kIsWeb) return _webBaseUrl;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidBaseUrl;
    }
    return _iosBaseUrl;
  }
}
