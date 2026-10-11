class Student {
  final int id;
  final String studentCode;
  final String fullName;
  final String gender;
  final int? cohortId;
  final int? entryYearId;
  final String status;
  final String? photo;
  final String? phone;
  final String? email;
  final String? address;
  final String? cohortName;
  final String? dob;

  Student({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.gender,
    this.cohortId,
    this.entryYearId,
    required this.status,
    this.photo,
    this.phone,
    this.email,
    this.address,
    this.cohortName,
    this.dob,
  });

  // ============================================================
  // FROM JSON — បំប្លែងពី JSON ទៅ Object (Safe)
  // ============================================================
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: _toInt(json['id']),
      studentCode: _toStr(json['student_code']),
      fullName: _toStr(json['full_name']),
      gender: _toStr(json['gender'], fallback: 'M'),
      cohortId: json['cohort_id'] != null ? _toInt(json['cohort_id']) : null,
      entryYearId:
          json['entry_year_id'] != null ? _toInt(json['entry_year_id']) : null,
      status: _toStr(json['status'], fallback: 'active'),
      photo: _toStrOrNull(json['photo']),
      phone: _toStrOrNull(json['phone']),
      email: _toStrOrNull(json['email']),
      address: _toStrOrNull(json['address']),
      cohortName: _toStrOrNull(json['cohort_name']),
      dob: _toStrOrNull(json['dob']),
    );
  }

  // ============================================================
  // TO JSON — បំប្លែងពី Object ទៅ JSON
  // ============================================================
  Map<String, dynamic> toJson() {
    return {
      'student_code': studentCode,
      'full_name': fullName,
      'gender': gender,
      'cohort_id': cohortId,
      'entry_year_id': entryYearId,
      'status': status,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  // ============================================================
  // ✅ HELPERS — Safe Conversion
  // ============================================================

  // បំប្លែងទៅ String (មាន Fallback)
  static String _toStr(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  // បំប្លែងទៅ String ឬ Null
  static String? _toStrOrNull(dynamic value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }

  // បំប្លែងទៅ Int
  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  // ============================================================
  // GETTERS
  // ============================================================
  String get genderLabel => gender == 'M' ? 'ប្រុស' : 'ស្រី';

  String get statusLabel {
    switch (status) {
      case 'active':
        return 'កំពុងរៀន';
      case 'graduated':
        return 'បញ្ចប់';
      case 'dropped':
        return 'ឈប់';
      default:
        return status;
    }
  }

  // ✅ ពិនិត្យថាមានរូបថត
  bool get hasPhoto {
    if (photo == null) return false;
    if (photo!.isEmpty) return false;
    if (photo == 'null') return false;
    return true;
  }
}