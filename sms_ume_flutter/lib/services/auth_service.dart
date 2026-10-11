import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const String _keyUser = 'user_data';
  static const String _keyToken = 'auth_token';

  // ✅ Login
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final res = await ApiService.post('auth/login.php', {
        'username': username,
        'password': password,
      });

      if (res['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUser, res['user'].toString());
        if (res['token'] != null) {
          await prefs.setString(_keyToken, res['token']);
        }
        return res['user'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ Check Logged In
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser) != null;
  }
}