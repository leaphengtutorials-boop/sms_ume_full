import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/enrollment_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  int? _subjectId;
  List<Map<String, dynamic>> _students = [];
  Map<int, String> _selected = {};
  bool _loading = false;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('📝 ចុះឈ្មោះចូលរៀន')),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          // Dropdown + Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _subjectId,
                  decoration: const InputDecoration(labelText: 'ជ្រើសមុខវិជ្ជា'),
                  items: app.subjects.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.subjectCode} — ${s.subjectName}'),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() => _subjectId = v);
                    if (v != null) _loadStudents(v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '🔍 ស្វែងរក...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ],
            ),
          ),

          // Action Buttons
          if (_subjectId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectAll,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('ជ្រើសទាំងអស់'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _deselectAll,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('ដកទាំងអស់'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _subjectId == null
                    ? const Center(child: Text('សូមជ្រើសមុខវិជ្ជា'))
                    : RefreshIndicator(
                        onRefresh: () => _loadStudents(_subjectId!),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (_, i) {
                            final s = _filteredStudents[i];
                            return _studentRow(s);
                          },
                        ),
                      ),
          ),

          // Save Button
          if (_subjectId != null && _students.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text('💾 រក្សាទុក (${_selected.length} នាក់)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_search.isEmpty) return _students;
    final q = _search.toLowerCase();
    return _students.where((s) {
      return (s['full_name'] ?? '').toString().toLowerCase().contains(q) ||
          (s['student_code'] ?? '').toString().toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _loadStudents(int subjectId) async {
    setState(() => _loading = true);
    try {
      final list = await EnrollmentService.list(subjectId: subjectId);
      setState(() {
        _students = list;
        _selected.clear();
        for (final s in list) {
          if (s['enrolled'] == 1) {
            _selected[s['id']] = s['enroll_status'] ?? 'active';
          }
        }
      });
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _studentRow(Map<String, dynamic> s) {
    final sid = s['id'] as int;
    final isEnrolled = s['enrolled'] == 1;
    final otherActive = int.tryParse('${s['other_active_count'] ?? 0}') ?? 0;
    final isBusy = otherActive > 0 && !isEnrolled;

    final isChecked = _selected.containsKey(sid);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isEnrolled
            ? const Color(0xFFEFF6FF)
            : isBusy
                ? const Color(0xFFFFFBEB)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isEnrolled
                ? AppTheme.info
                : isBusy
                    ? AppTheme.warning
                    : Colors.transparent,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: isBusy && !isEnrolled
            ? null
            : (v) {
                setState(() {
                  if (v == true) {
                    _selected[sid] = 'active';
                  } else {
                    _selected.remove(sid);
                  }
                });
              },
        title: Text(
          s['full_name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📌 ${s['student_code'] ?? ''} · 🎓 ${s['cohort_name'] ?? "-"}'),
            if (isBusy)
              const Text(
                '🔒 កំពុងរៀនមុខវិជ្ជាផ្សេង',
                style: TextStyle(color: AppTheme.warning, fontSize: 12),
              ),
          ],
        ),
        secondary: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Text(
            s['gender'] == 'M' ? '👨' : '👩',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void _selectAll() {
    setState(() {
      for (final s in _filteredStudents) {
        final sid = s['id'] as int;
        final isEnrolled = s['enrolled'] == 1;
        final otherActive = int.tryParse('${s['other_active_count'] ?? 0}') ?? 0;
        if (!(otherActive > 0 && !isEnrolled)) {
          _selected[sid] = _selected[sid] ?? 'active';
        }
      }
    });
  }

  void _deselectAll() {
    setState(() => _selected.clear());
  }

  Future<void> _save() async {
    if (_subjectId == null) return;

    final students = _selected.entries
        .map((e) => {'id': e.key, 'status': e.value})
        .toList();

    try {
      final res = await EnrollmentService.save(
        subjectId: _subjectId!,
        students: students,
      );
      if (res['success'] == true) {
        _showSnack(res['message'] ?? '✅ រក្សាទុកជោគជ័យ', AppTheme.success);
        _loadStudents(_subjectId!);
      } else {
        _showSnack(res['error'] ?? 'បរាជ័យ', AppTheme.danger);
      }
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}