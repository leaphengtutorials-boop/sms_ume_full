class Subject {
  final int id;
  final String subjectCode;
  final String subjectName;
  final int academicYearId;
  final int studyYear;
  final int semester;
  final int totalWeeks;
  final String? yearName;
  final int studentCount;
  final int completedCount;
  final String? cohortsInfo;

  Subject({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.academicYearId,
    required this.studyYear,
    required this.semester,
    required this.totalWeeks,
    this.yearName,
    this.studentCount = 0,
    this.completedCount = 0,
    this.cohortsInfo,
  });

  // ✅ បម្លែងពី JSON → Object
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? 0,
      subjectCode: json['subject_code'] ?? '',
      subjectName: json['subject_name'] ?? '',
      academicYearId: json['academic_year_id'] ?? 0,
      studyYear: json['study_year'] ?? 1,
      semester: json['semester'] ?? 1,
      totalWeeks: json['total_weeks'] ?? 15,
      yearName: json['year_name'],
      studentCount: int.tryParse(json['student_count']?.toString() ?? '0') ?? 0,
      completedCount: int.tryParse(json['completed_count']?.toString() ?? '0') ?? 0,
      cohortsInfo: json['cohorts_info'],
    );
  }

  // ✅ បម្លែងពី Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'academic_year_id': academicYearId,
      'study_year': studyYear,
      'semester': semester,
      'total_weeks': totalWeeks,
    };
  }
}