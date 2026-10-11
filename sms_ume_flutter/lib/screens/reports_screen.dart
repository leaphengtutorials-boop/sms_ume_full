import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/reports_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int? _subjectId;
  Map<String, dynamic>? _report;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('📈 លទ្ធផល')),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: DropdownButtonFormField<int>(
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
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _subjectId == null
                    ? const Center(child: Text('សូមជ្រើសមុខវិជ្ជា'))
                    : _report == null
                        ? const Center(child: Text('មិនមានទិន្នន័យ'))
                        : _buildReport(),
          ),
        ],
      ),
    );
  }

  Widget _buildReport() {
    final results = List<Map<String, dynamic>>.from(
      _report!['results'] ?? [],
    );
    final subject = _report!['subject'] ?? {};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  subject['subject_name'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${results.length} នាក់',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Results
        ...results.map((r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['full_name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '📌 ${r['student_code'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${r['total_score'] ?? 0}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            _gradeBadge(r['grade'] ?? 'F'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      children: [
                        _scoreChip('Att', r['attendance_score']),
                        _scoreChip('HW', r['scores']?['homework']),
                        _scoreChip('Quiz', r['scores']?['quiz']),
                        _scoreChip('Mid', r['scores']?['midterm']),
                        _scoreChip('Asg', r['scores']?['assignment']),
                        _scoreChip('Final', r['scores']?['final']),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _gradeBadge(String grade) {
    final colors = {
      'A': AppTheme.success,
      'B': AppTheme.info,
      'C': const Color(0xFF8B5CF6),
      'D': AppTheme.warning,
      'E': const Color(0xFFF97316),
      'F': AppTheme.danger,
    };
    final color = colors[grade] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        grade,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _scoreChip(String label, dynamic value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(
            '${value ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _load() async {
    if (_subjectId == null) return;
    setState(() {
      _loading = true;
      _report = null;
    });
    try {
      final res = await ReportsService.load(subjectId: _subjectId!);
      setState(() => _report = res);
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}