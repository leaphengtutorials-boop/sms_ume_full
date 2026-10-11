import 'api_service.dart';

class ScoresService {
  // ✅ Midterm
  static Future<Map<String, dynamic>> midtermList({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    return await ApiService.get('scores.php', params: {
      'subject_id': '$subjectId',
      'type': 'midterm',
      ...?filters,
    });
  }

  static Future<Map<String, dynamic>> midtermSave({
    required int subjectId,
    required String title,
    String? examDate,
    required List<Map<String, dynamic>> records,
  }) async {
    return await ApiService.post('scores.php', {
      'subject_id': subjectId,
      'score_type': 'midterm',
      'title': title,
      'exam_date': examDate,
      'max_score': 100,
      'records': records,
    });
  }

  // ✅ Final
  static Future<Map<String, dynamic>> finalList({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    return await ApiService.get('final_scores.php', params: {
      'subject_id': '$subjectId',
      ...?filters,
    });
  }

  static Future<Map<String, dynamic>> finalSave({
    required int subjectId,
    required String title,
    String? examDate,
    required List<Map<String, dynamic>> records,
  }) async {
    return await ApiService.post('final_scores.php', {
      'subject_id': subjectId,
      'title': title,
      'exam_date': examDate,
      'records': records,
    });
  }

  static Future<Map<String, dynamic>> finalDelete(int subjectId) async {
    return await ApiService.delete('final_scores.php?subject_id=$subjectId');
  }
}