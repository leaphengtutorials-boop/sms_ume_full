import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../services/attendance_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int? _subjectId;
  int _week = 1;
  int _totalWeeks = 15;
  List<Map<String, dynamic>> _students = [];
  bool _loading = false;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('✅ វត្តមាន')),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          // Subject + Week
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _subjectId,
                  decoration: const InputDecoration(labelText: 'មុខវិជ្ជា'),
                  items: app.subjects.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.subjectCode} — ${s.subjectName}'),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _subjectId = v;
                      if (v != null) {
                        _totalWeeks =
                            app.getSubjectById(v)?.totalWeeks ?? 15;
                        _week = 1;
                      }
                    });
                    if (v != null) _load();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _week,
                        decoration: const InputDecoration(labelText: 'សប្តាហ៍'),
                        items: List.generate(_totalWeeks, (i) => i + 1)
                            .map((i) => DropdownMenuItem(
                                  value: i,
                                  child: Text('សប្តាហ៍ $i'),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _week = v ?? 1);
                          _load();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'កាលបរិច្ឆេទ',
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(_date),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary
          if (_students.isNotEmpty) _buildSummary(),

          // Actions
          if (_students.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _markAll('present'),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('ទាំងអស់'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _markAll('absent'),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('អវត្តមាន'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _subjectId == null
                    ? const Center(child: Text('សូមជ្រើសមុខវិជ្ជា'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _students.length,
                        itemBuilder: (_, i) => _studentRow(_students[i], i),
                      ),
          ),

          // Save Button
          if (_students.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('💾 រក្សាទុកវត្តមាន'),
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

  Widget _buildSummary() {
    final counts = {'present': 0, 'late': 0, 'absent': 0, 'permission': 0};
    for (final s in _students) {
      final st = s['status'] as String? ?? 'absent';
      counts[st] = (counts[st] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _summaryCard('✅ មាន', counts['present']!, AppTheme.success),
          const SizedBox(width: 8),
          _summaryCard('⏰ យឺត', counts['late']!, AppTheme.warning),
          const SizedBox(width: 8),
          _summaryCard('📝 ច្បាប់', counts['permission']!, AppTheme.info),
          const SizedBox(width: 8),
          _summaryCard('❌ អវត្តមាន', counts['absent']!, AppTheme.danger),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentRow(Map<String, dynamic> s, int index) {
    final status = s['status'] as String? ?? 'absent';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              child: Text(
                s['gender'] == 'M' ? '👨' : '👩',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['full_name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '📌 ${s['student_code'] ?? ''}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: status,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'present', child: Text('✅')),
                DropdownMenuItem(value: 'late', child: Text('⏰')),
                DropdownMenuItem(value: 'permission', child: Text('📝')),
                DropdownMenuItem(value: 'absent', child: Text('❌')),
              ],
              onChanged: (v) {
                setState(() => s['status'] = v);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _load() async {
    if (_subjectId == null) return;
    setState(() => _loading = true);
    try {
      final list = await AttendanceService.take(
        subjectId: _subjectId!,
        week: _week,
      );
      setState(() => _students = list);
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _markAll(String status) {
    setState(() {
      for (final s in _students) {
        s['status'] = status;
      }
    });
  }

  Future<void> _save() async {
    if (_subjectId == null || _students.isEmpty) return;
    try {
      final res = await AttendanceService.save(
        subjectId: _subjectId!,
        week: _week,
        attendDate: DateFormat('yyyy-MM-dd').format(_date),
        records: _students.map((s) => {
              'student_id': s['student_id'],
              'status': s['status'] ?? 'absent',
              'note': s['note'] ?? '',
            }).toList(),
      );
      if (res['success'] == true) {
        _showSnack(res['message'] ?? '✅ រក្សាទុកជោគជ័យ', AppTheme.success);
      }
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}