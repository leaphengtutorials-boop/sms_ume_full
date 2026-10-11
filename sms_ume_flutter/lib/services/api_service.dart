import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // ✅ GET Request
  static Future<dynamic> get(String endpoint,
      {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint')
          .replace(queryParameters: params);

      final response = await http.get(uri);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ✅ POST Request
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ✅ PUT Request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // ✅ DELETE Request
  static Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.delete(uri);
    return _handleResponse(response);
  }

  // ✅ Handle Response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // បន្ថែម Method នេះចូល class ApiService

  static Future<dynamic> patch(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
