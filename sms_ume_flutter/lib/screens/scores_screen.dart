import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../services/scores_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  int? _subjectId;
  List<Map<String, dynamic>> _students = [];
  final Map<int, TextEditingController> _controllers = {};
  bool _loading = false;
  final _titleCtrl = TextEditingController(text: 'Midterm Exam');
  DateTime _examDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('📝 ពិន្ទុ Midterm')),
      drawer: const MainDrawer(),
      body: Column(
        children: [
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
                    setState(() => _subjectId = v);
                    if (v != null) _load();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'ចំណងជើង',
                        ),
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
                            DateFormat('dd/MM/yyyy').format(_examDate),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _subjectId == null
                    ? const Center(child: Text('សូមជ្រើសមុខវិជ្ជា'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _students.length,
                        itemBuilder: (_, i) => _scoreRow(_students[i], i),
                      ),
          ),

          if (_students.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('💾 រក្សាទុក'),
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

  Widget _scoreRow(Map<String, dynamic> s, int index) {
    final sid = s['student_id'] as int;
    _controllers.putIfAbsent(sid, () => TextEditingController());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              child: Text(s['gender'] == 'M' ? '👨' : '👩'),
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
            SizedBox(
              width: 80,
              child: TextField(
                controller: _controllers[sid],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '0-100',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
              ),
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
      final res = await ScoresService.midtermList(subjectId: _subjectId!);
      final students = List<Map<String, dynamic>>.from(res['students'] ?? []);
      final scores = res['scores'] as Map<String, dynamic>? ?? {};

      // Init controllers
      for (final c in _controllers.values) c.dispose();
      _controllers.clear();

      for (final s in students) {
        final sid = s['student_id'] as int;
        final score = scores['$sid'];
        _controllers[sid] = TextEditingController(
          text: score != null ? score.toString() : '',
        );
      }

      setState(() => _students = students);
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_subjectId == null) return;

    final records = <Map<String, dynamic>>[];
    _controllers.forEach((sid, ctrl) {
      if (ctrl.text.isNotEmpty) {
        final v = double.tryParse(ctrl.text);
        if (v != null) records.add({'student_id': sid, 'score': v});
      }
    });

    if (records.isEmpty) {
      _showSnack('សូមបញ្ចូលពិន្ទុ', AppTheme.warning);
      return;
    }

    try {
      final res = await ScoresService.midtermSave(
        subjectId: _subjectId!,
        title: _titleCtrl.text,
        examDate: DateFormat('yyyy-MM-dd').format(_examDate),
        records: records,
      );
      if (res['success'] == true) {
        _showSnack(res['message'] ?? '✅ ជោគជ័យ', AppTheme.success);
      }
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }
}