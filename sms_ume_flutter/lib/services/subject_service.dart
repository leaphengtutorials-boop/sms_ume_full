import '../models/subject.dart';
import 'api_service.dart';

class SubjectService {
  // ✅ ទាញបញ្ជីមុខវិជ្ជា
  static Future<List<Subject>> list({Map<String, String>? filters}) async {
    final data = await ApiService.get('subjects.php', params: filters);
    if (data is List) {
      return data.map((j) => Subject.fromJson(j)).toList();
    }
    return [];
  }

  // ✅ បង្កើតមុខវិជ្ជាថ្មី
  static Future<bool> create(Map<String, dynamic> data) async {
    final res = await ApiService.post('subjects.php', data);
    return res['success'] == true;
  }

  // ✅ កែមុខវិជ្ជា
  static Future<bool> update(Map<String, dynamic> data) async {
    final res = await ApiService.put('subjects.php', data);
    return res['success'] == true;
  }

  // ✅ លុបមុខវិជ្ជា
  static Future<bool> remove(int id) async {
    final res = await ApiService.delete('subjects.php?id=$id');
    return res['success'] == true;
  }
}