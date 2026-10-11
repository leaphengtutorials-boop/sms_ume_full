import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? user;
  bool loading = false;
  String? error;

  Future<bool> login(String username, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await AuthService.login(username, password);
      if (res != null) {
        user = res;
        loading = false;
        notifyListeners();
        return true;
      } else {
        error = 'ឈ្មោះអ្នកប្រើ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ';
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    user = null;
    notifyListeners();
  }
}