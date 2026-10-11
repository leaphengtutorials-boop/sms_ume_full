class Cohort {
  final int id;
  final String cohortName;
  final bool isCurrent;

  Cohort({
    required this.id,
    required this.cohortName,
    required this.isCurrent,
  });

  factory Cohort.fromJson(Map<String, dynamic> json) {
    return Cohort(
      id: json['id'] ?? 0,
      cohortName: json['cohort_name'] ?? '',
      isCurrent: json['is_current'] == 1,
    );
  }
}