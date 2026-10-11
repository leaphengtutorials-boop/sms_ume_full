import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../services/homework_service.dart';
import '../config/theme.dart';

class HomeworkFormScreen extends StatefulWidget {
  final int subjectId;
  final int? cohortId;

  const HomeworkFormScreen({
    super.key,
    required this.subjectId,
    this.cohortId,
  });

  @override
  State<HomeworkFormScreen> createState() => _HomeworkFormScreenState();
}

class _HomeworkFormScreenState extends State<HomeworkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _maxScoreCtrl = TextEditingController(text: '100');

  int? _cohortId;
  String _type = 'homework';
  DateTime? _dueDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _cohortId = widget.cohortId;
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final subject = app.getSubjectById(widget.subjectId);
    final currentCohorts = app.cohorts.where((c) => c.isCurrent).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('➕ បង្កើតកិច្ចការថ្មី')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Subject Info
            if (subject != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📚 ${subject.subjectCode} — ${subject.subjectName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '📖 ឆ្នាំទី ${subject.studyYear} · 📅 ឆមាស ${subject.semester}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Cohort
            DropdownButtonFormField<int>(
              value: _cohortId,
              decoration: const InputDecoration(
                labelText: 'ជំនាន់ *',
                prefixIcon: Icon(Icons.school),
              ),
              items: currentCohorts.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.cohortName} ⭐'),
                );
              }).toList(),
              validator: (v) => v == null ? 'សូមជ្រើសជំនាន់' : null,
              onChanged: (v) => setState(() => _cohortId = v),
            ),
            const SizedBox(height: 16),

            // Type
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'ប្រភេទ *',
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(value: 'homework', child: Text('📝 Homework')),
                DropdownMenuItem(value: 'quiz', child: Text('❓ Quiz')),
                DropdownMenuItem(value: 'assignment', child: Text('📋 Assignment')),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'homework'),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'ចំណងជើង *',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) => v?.isEmpty == true ? 'សូមបំពេញចំណងជើង' : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ការពិពណ៌នា',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Due Date
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'ផុតកំណត់',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dueDate != null
                      ? DateFormat('dd/MM/yyyy').format(_dueDate!)
                      : 'ជ្រើសកាលបរិច្ឆេទ',
                  style: TextStyle(
                    color: _dueDate != null ? Colors.black : AppTheme.gray,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Max Score
            TextFormField(
              controller: _maxScoreCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ពិន្ទុពេញ *',
                prefixIcon: Icon(Icons.star),
              ),
              validator: (v) {
                if (v?.isEmpty == true) return 'សូមបំពេញពិន្ទុ';
                final n = double.tryParse(v!);
                if (n == null || n <= 0) return 'ពិន្ទុត្រូវធំជាង 0';
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
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
                label: Text(_saving ? 'កំពុងរក្សាទុក...' : '💾 រក្សាទុក'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cohortId == null) return;

    setState(() => _saving = true);
    try {
      final res = await HomeworkService.create(
        subjectId: widget.subjectId,
        cohortId: _cohortId!,
        type: _type,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        dueDate: _dueDate != null
            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
            : null,
        maxScore: double.tryParse(_maxScoreCtrl.text) ?? 100,
      );

      if (res['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ បង្កើតកិច្ចការជោគជ័យ'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showError(res['error'] ?? 'បរាជ័យ');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }
}