import 'package:flutter/material.dart';
import '../services/homework_service.dart';
import '../config/theme.dart';

class HomeworkDetailScreen extends StatefulWidget {
  final Map<String, dynamic> homework;

  const HomeworkDetailScreen({super.key, required this.homework});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  Map<String, dynamic>? _data;
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;
  bool _saving = false;

  bool get _isReadonly {
    final h = _data?['homework'] ?? widget.homework;
    return _data?['is_readonly'] == true || h['is_current'] == 0;
  }

  double get _maxScore {
    final h = _data?['homework'] ?? widget.homework;
    return double.tryParse('${h['max_score'] ?? 100}') ?? 100;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final h = _data?['homework'] ?? widget.homework;

    return Scaffold(
      appBar: AppBar(
        title: Text(h['title'] ?? 'កិច្ចការ'),
        actions: [
          // ✅ ប្រើ _saving ត្រឹមត្រូវ
          if (!_isReadonly && !_loading)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                tooltip: _saving ? 'កំពុងរក្សាទុក...' : 'រក្សាទុក',
                onPressed: _saving ? null : _save,
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Readonly Banner
                if (_isReadonly)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: AppTheme.warning.withOpacity(0.15),
                    child: const Row(
                      children: [
                        Icon(Icons.lock, color: AppTheme.warning),
                        SizedBox(width: 8),
                        Text(
                          'ជំនាន់បានបញ្ចប់ — Read Only',
                          style: TextStyle(
                            color: AppTheme.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.primaryLight,
                  child: Row(
                    children: [
                      Expanded(
                        child: _infoItem('🎓 ជំនាន់', h['cohort_name'] ?? '-'),
                      ),
                      Expanded(
                        child: _infoItem('👥 សិស្ស', '${_students.length}'),
                      ),
                      Expanded(
                        child: _infoItem('🎯 ពិន្ទុពេញ', '$_maxScore'),
                      ),
                    ],
                  ),
                ),

                // Actions
                if (!_isReadonly && _students.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _markAll(true),
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
                            onPressed: () => _markAll(false),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text('មិនដាក់'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.danger,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _fillFull,
                            icon: const Icon(Icons.star, size: 16),
                            label: const Text('ពេញ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Students List
                Expanded(
                  child: _students.isEmpty
                      ? const Center(
                          child: Text('មិនមានសិស្សក្នុងជំនាន់នេះ'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _students.length,
                          itemBuilder: (_, i) => _studentRow(_students[i], i),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.gray),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _studentRow(Map<String, dynamic> s, int i) {
    final sid = s['student_id'];
    final submitted = s['submitted'] == 1 || s['submitted'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryLight,
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
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.gray,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            Checkbox(
              value: submitted,
              onChanged: _isReadonly
                  ? null
                  : (v) {
                      setState(() {
                        s['submitted'] = v == true ? 1 : 0;
                        if (v != true) s['score'] = null;
                      });
                    },
            ),
            // Score
            SizedBox(
              width: 70,
              child: TextField(
                controller: _getScoreCtrl(sid, s['score']),
                enabled: submitted && !_isReadonly,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '0',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Map<dynamic, TextEditingController> _scoreCtrls = {};

  TextEditingController _getScoreCtrl(dynamic sid, dynamic score) {
    if (!_scoreCtrls.containsKey(sid)) {
      _scoreCtrls[sid] = TextEditingController(
        text: score != null ? '$score' : '',
      );
    }
    return _scoreCtrls[sid]!;
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await HomeworkService.get(widget.homework['id']);
      final students = List<Map<String, dynamic>>.from(res['students'] ?? []);

      // Clear ctrls
      for (final c in _scoreCtrls.values) c.dispose();
      _scoreCtrls.clear();

      setState(() {
        _data = res;
        _students = students;
      });
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _markAll(bool submitted) {
    setState(() {
      for (final s in _students) {
        s['submitted'] = submitted ? 1 : 0;
        if (!submitted) {
          s['score'] = null;
          _scoreCtrls[s['student_id']]?.text = '';
        }
      }
    });
  }

  void _fillFull() {
    setState(() {
      for (final s in _students) {
        s['submitted'] = 1;
        s['score'] = _maxScore;
        final ctrl = _scoreCtrls.putIfAbsent(
          s['student_id'],
          () => TextEditingController(),
        );
        ctrl.text = '$_maxScore';
      }
    });
  }

  Future<void> _save() async {
    final submissions = <Map<String, dynamic>>[];
    for (final s in _students) {
      final ctrl = _scoreCtrls[s['student_id']];
      double? score;
      if (ctrl != null && ctrl.text.isNotEmpty) {
        score = double.tryParse(ctrl.text);
      }

      submissions.add({
        'student_id': s['student_id'],
        'submitted': s['submitted'] == 1 ? 1 : 0,
        'score': score,
      });
    }

    setState(() => _saving = true);
    try {
      final res = await HomeworkService.saveSubmissions(
        homeworkId: widget.homework['id'],
        submissions: submissions,
      );
      if (res['success'] == true) {
        _showSnack('✅ រក្សាទុកជោគជ័យ', AppTheme.success);
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _saving = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    for (final c in _scoreCtrls.values) c.dispose();
    super.dispose();
  }
}
