import 'api_service.dart';

class ReportsService {
  static Future<Map<String, dynamic>> load({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    return await ApiService.get('reports.php', params: {
      'subject_id': '$subjectId',
      ...?filters,
    });
  }

  static Future<List<Map<String, dynamic>>> completed({
    Map<String, String>? filters,
  }) async {
    final data = await ApiService.get('completed_students.php', params: filters);
    if (data is List) return List<Map<String, dynamic>>.from(data);
    return [];
  }
}