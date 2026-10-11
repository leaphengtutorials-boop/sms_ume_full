import 'api_service.dart';

class EnrollmentService {
  // ✅ ទាញបញ្ជីសិស្សក្នុងមុខវិជ្ជា
  static Future<List<Map<String, dynamic>>> list({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    final params = {
      'subject_id': '$subjectId',
      ...?filters,
    };
    final data = await ApiService.get('enrollment.php', params: params);
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  // ✅ រក្សាទុកការចុះឈ្មោះ
  static Future<Map<String, dynamic>> save({
    required int subjectId,
    required List<Map<String, dynamic>> students,
  }) async {
    return await ApiService.post('enrollment.php', {
      'subject_id': subjectId,
      'students': students,
    });
  }

  // ✅ ផ្លាស់ប្តូរ Status
  static Future<Map<String, dynamic>> changeStatus({
    required int studentId,
    required int subjectId,
    required String status,
  }) async {
    return await ApiService.patch('enrollment.php', {
      'student_id': studentId,
      'subject_id': subjectId,
      'status': status,
    });
  }

  // ✅ Bulk Complete
  static Future<Map<String, dynamic>> bulkComplete({
    required int subjectId,
    required List<int> studentIds,
  }) async {
    return await ApiService.post('bulk_complete.php', {
      'subject_id': subjectId,
      'student_ids': studentIds,
    });
  }
}