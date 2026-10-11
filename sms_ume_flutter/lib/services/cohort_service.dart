import 'api_service.dart';

class CohortService {
  // ✅ ទាញបញ្ជីជំនាន់
  static Future<Map<String, dynamic>> list() async {
    return await ApiService.get('cohorts.php');
  }

  // ✅ បង្កើតជំនាន់ថ្មី
  static Future<bool> create({
    required String cohortName,
    String? description,
  }) async {
    final res = await ApiService.post('cohorts.php', {
      'cohort_name': cohortName,
      'description': description,
    });
    return res['success'] == true;
  }

  // ✅ កំណត់ជំនាន់បច្ចុប្បន្ន
  static Future<bool> setCurrent(int id) async {
    final res = await ApiService.put(
      'cohorts.php?id=$id&set_current=1',
      {},
    );
    return res['success'] == true;
  }

  // ✅ កែជំនាន់
  static Future<bool> update({
    required int id,
    required String cohortName,
    String? description,
  }) async {
    final res = await ApiService.put('cohorts.php', {
      'id': id,
      'cohort_name': cohortName,
      'description': description,
    });
    return res['success'] == true;
  }

  // ✅ លុបជំនាន់
  static Future<bool> remove(int id) async {
    final res = await ApiService.delete('cohorts.php?id=$id');
    return res['success'] == true;
  }
}