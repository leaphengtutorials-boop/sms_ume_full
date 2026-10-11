import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class StudentService {
  // ============================================================
  // LIST — ទាញបញ្ជីសិស្ស
  // ============================================================
  static Future<List<Student>> list({Map<String, String>? filters}) async {
    final data = await ApiService.get('students.php', params: filters);
    if (data is List) {
      return data.map((j) => Student.fromJson(j)).toList();
    }
    return [];
  }

  // ============================================================
  // GET — ទាញសិស្សម្នាក់
  // ============================================================
  static Future<Student?> get(int id) async {
    final data = await ApiService.get('students.php', params: {'id': '$id'});
    if (data is Map<String, dynamic>) {
      return Student.fromJson(data);
    }
    return null;
  }

  // ============================================================
  // CREATE — បង្កើតសិស្សថ្មី (គ្មានរូបថត)
  // ============================================================
  static Future<bool> create(Map<String, dynamic> data) async {
    final res = await ApiService.post('students.php', data);
    return res['success'] == true;
  }

  // ============================================================
  // UPDATE — កែព័ត៌មានសិស្ស
  // ============================================================
  static Future<bool> update(Map<String, dynamic> data) async {
    final res = await ApiService.put('students.php', data);
    return res['success'] == true;
  }

  // ============================================================
  // DELETE — លុបសិស្ស
  // ============================================================
  static Future<bool> remove(int id) async {
    final res = await ApiService.delete('students.php?id=$id');
    return res['success'] == true;
  }

  // ============================================================
  // HISTORY — ប្រវត្តិមុខវិជ្ជា
  // ============================================================
  static Future<List<Map<String, dynamic>>> history(int studentId) async {
    final data = await ApiService.get('enrollment.php', params: {
      'history': '1',
      'student_id': '$studentId',
    });
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  // ============================================================
  // ✅ UPLOAD PHOTO — Upload រូបថតសិស្ស
  // ============================================================
  static Future<String?> uploadPhoto({
    required int studentId,
    required File photo,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/photo.php');

      final request = http.MultipartRequest('POST', uri)
        ..fields['student_id'] = '$studentId'
        ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

      final streamedRes = await request.send();
      final res = await http.Response.fromStream(streamedRes);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        if (data['success'] == true) {
          return data['photo'];
        }
      }
      return null;
    } catch (e) {
      print('Upload Photo Error: $e');
      return null;
    }
  }

  // ============================================================
  // ✅ DELETE PHOTO — លុបរូបថតសិស្ស
  // ============================================================
  static Future<bool> deletePhoto(int studentId) async {
    try {
      final res = await ApiService.delete('photo.php?student_id=$studentId');
      return res['success'] == true;
    } catch (e) {
      print('Delete Photo Error: $e');
      return false;
    }
  }

  // ============================================================
  // ✅ CREATE WITH PHOTO — បង្កើតសិស្សថ្មី + រូបថត
  // ============================================================
  static Future<bool> createWithPhoto({
    required Map<String, dynamic> data,
    File? photo,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/students.php');

      final request = http.MultipartRequest('POST', uri);

      // ✅ Add Fields — ដក null ចេញ
      data.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          request.fields[key] = value.toString();
        }
      });

      // ✅ Add Photo
      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }

      final streamedRes = await request.send();
      final res = await http.Response.fromStream(streamedRes);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resData = jsonDecode(utf8.decode(res.bodyBytes));
        return resData['success'] == true;
      }
      return false;
    } catch (e) {
      print('Create With Photo Error: $e');
      return false;
    }
  }
}