import 'api_service.dart';

class HomeworkService {
  // ✅ ទាញបញ្ជីកិច្ចការ
  static Future<List<Map<String, dynamic>>> list({
    required int subjectId,
    Map<String, String>? filters,
  }) async {
    final data = await ApiService.get('homework.php', params: {
      'subject_id': '$subjectId',
      ...?filters,
    });
    if (data is List) return List<Map<String, dynamic>>.from(data);
    return [];
  }

  // ✅ ទាញព័ត៌មានលម្អិតកិច្ចការ + បញ្ជីសិស្ស
  static Future<Map<String, dynamic>> get(int id) async {
    return await ApiService.get('homework.php', params: {'id': '$id'});
  }

  // ✅ បង្កើតកិច្ចការថ្មី
  static Future<Map<String, dynamic>> create({
    required int subjectId,
    required int cohortId,
    required String type,
    required String title,
    String? description,
    String? dueDate,
    required double maxScore,
  }) async {
    return await ApiService.post('homework.php', {
      'subject_id': subjectId,
      'cohort_id': cohortId,
      'type': type,
      'title': title,
      'description': description ?? '',
      'due_date': dueDate,
      'max_score': maxScore,
    });
  }

  // ✅ រក្សាទុកពិន្ទុសិស្ស
  static Future<Map<String, dynamic>> saveSubmissions({
    required int homeworkId,
    required List<Map<String, dynamic>> submissions,
  }) async {
    return await ApiService.post('homework.php', {
      'homework_id': homeworkId,
      'submissions': submissions,
    });
  }

  // ✅ លុបកិច្ចការ
  static Future<Map<String, dynamic>> remove(int id) async {
    return await ApiService.delete('homework.php?id=$id');
  }
}