import 'api_service.dart';

class AttendanceService {
  // ✅ ទាញបញ្ជីសិស្សស្រង់វត្តមាន
  static Future<List<Map<String, dynamic>>> take({
    required int subjectId,
    required int week,
    Map<String, String>? filters,
  }) async {
    final data = await ApiService.get('attendance.php', params: {
      'subject_id': '$subjectId',
      'week': '$week',
      ...?filters,
    });
    if (data is List) return List<Map<String, dynamic>>.from(data);
    return [];
  }

  // ✅ ទាញរបាយការណ៍
  static Future<Map<String, dynamic>> report({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    return await ApiService.get('attendance.php', params: {
      'report': '1',
      'subject_id': '$subjectId',
      ...?filters,
    });
  }

  // ✅ ទាញសប្តាហ៍ចុងក្រោយ
  static Future<Map<String, dynamic>> lastWeek({
    required int subjectId,
  }) async {
    return await ApiService.get('attendance.php', params: {
      'last_week': '1',
      'subject_id': '$subjectId',
    });
  }

  // ✅ រក្សាទុកវត្តមាន
  static Future<Map<String, dynamic>> save({
    required int subjectId,
    required int week,
    String? attendDate,
    required List<Map<String, dynamic>> records,
  }) async {
    return await ApiService.post('attendance.php', {
      'subject_id': subjectId,
      'week': week,
      'attend_date': attendDate,
      'records': records,
    });
  }
}