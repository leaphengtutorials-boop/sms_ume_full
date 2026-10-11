class ApiConfig {
  // ✅ ប្តូរ URL តាម Platform
  static String get baseUrl {
    // Web + Desktop
    if (const bool.fromEnvironment('dart.library.js_util')) {
      return 'http://192.168.20.29:8080/sms_ume/api';
    }
    
    // Android Emulator
    // (10.0.2.2 = localhost ពី Android Emulator)
    return 'http://10.0.2.2:8080/sms_ume/api';
  }

  static String get uploadUrl => baseUrl.replaceAll('/api', '/uploads');
}