class AcademicYear {
  final int id;
  final String yearName;
  final bool isActive;

  AcademicYear({
    required this.id,
    required this.yearName,
    required this.isActive,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['id'] ?? 0,
      yearName: json['year_name'] ?? '',
      isActive: json['is_active'] == 1,
    );
  }
}