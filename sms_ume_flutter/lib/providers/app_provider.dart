import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import '../models/cohort.dart';
import '../models/academic_year.dart';
import '../services/subject_service.dart';
import '../services/student_service.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  // ==================== STATE ====================
  List<Subject> subjects = [];
  List<Student> students = [];
  List<Cohort> cohorts = [];
  List<AcademicYear> years = [];

  int? currentCohortId;
  bool loading = false;
  String? error;

  // ==================== LOAD ALL ====================
  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      await Future.wait([
        loadSubjects(),
        loadStudents(),
        loadCohorts(),
        loadYears(),
      ]);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ==================== LOAD SUBJECTS ====================
  Future<void> loadSubjects({Map<String, String>? filters}) async {
    try {
      subjects = await SubjectService.list(filters: filters);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // ==================== LOAD STUDENTS (PUBLIC) ====================
  Future<void> loadStudents() async {
    try {
      students = await StudentService.list();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // ==================== LOAD COHORTS ====================
  Future<void> loadCohorts() async {
    try {
      final data = await ApiService.get('cohorts.php');
      final list = data['list'] ?? data;
      cohorts = (list as List).map((j) => Cohort.fromJson(j)).toList();
      currentCohortId = data['current_cohort_id'];
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // ==================== LOAD YEARS ====================
  Future<void> loadYears() async {
    try {
      final data = await ApiService.get('academic_years.php');
      years = (data as List).map((j) => AcademicYear.fromJson(j)).toList();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // ==================== HELPERS ====================
  Subject? getSubjectById(int id) {
    try {
      return subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Cohort? getCohortById(int id) {
    try {
      return cohorts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  int get activeStudentsCount =>
      students.where((s) => s.status == 'active').length;

  int get graduatedStudentsCount =>
      students.where((s) => s.status == 'graduated').length;
}