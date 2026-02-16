import 'package:flutter/foundation.dart';

class ApiConfig {
  // ---------------------------------------------------------------------------
  // PRODUCTION BACKEND CONFIGURATION
  // ---------------------------------------------------------------------------
  // Backend hosted on Hostinger: aqua-locust-289318.hostingersite.com
  // All platforms (Android, iOS, Web) will use the production backend
  // ---------------------------------------------------------------------------
  static const String _productionBaseUrl = 'https://aqua-locust-289318.hostingersite.com/api';

  static String get baseUrl {
    // Use production backend for all platforms
    return _productionBaseUrl;
  }
}
