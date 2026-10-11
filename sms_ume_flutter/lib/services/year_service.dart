import '../models/academic_year.dart';
import 'api_service.dart';

class YearService {
  // ✅ ទាញបញ្ជីឆ្នាំ
  static Future<List<AcademicYear>> list() async {
    final data = await ApiService.get('academic_years.php');
    if (data is List) {
      return data.map((j) => AcademicYear.fromJson(j)).toList();
    }
    return [];
  }

  // ✅ បង្កើតឆ្នាំថ្មី
  static Future<bool> create({
    required String yearName,
    String? startDate,
    String? endDate,
  }) async {
    final res = await ApiService.post('academic_years.php', {
      'year_name': yearName,
      'start_date': startDate,
      'end_date': endDate,
    });
    return res['success'] == true;
  }

  // ✅ លុបឆ្នាំ
  static Future<bool> remove(int id) async {
    final res = await ApiService.delete('academic_years.php?id=$id');
    return res['success'] == true;
  }
}