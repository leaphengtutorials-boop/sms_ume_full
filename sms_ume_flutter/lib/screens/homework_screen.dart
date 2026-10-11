import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/homework_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';
import 'homework_form_screen.dart';
import 'homework_detail_screen.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  int? _subjectId;
  int? _cohortId;
  String _typeFilter = '';
  List<Map<String, dynamic>> _homeworks = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 កិច្ចការ'),
        actions: [
          if (_subjectId != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openCreateForm(),
              tooltip: 'បន្ថែម',
            ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          // ==================== FILTERS ====================
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Subject
                DropdownButtonFormField<int>(
                  value: _subjectId,
                  decoration: const InputDecoration(
                    labelText: 'មុខវិជ្ជា',
                    prefixIcon: Icon(Icons.book),
                  ),
                  items: app.subjects.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        '${s.subjectCode} — ${s.subjectName}',
                        overflow: TextOverflow.ellipsis,
                      ),
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
                    // Cohort
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _cohortId,
                        decoration: const InputDecoration(
                          labelText: 'ជំនាន់',
                          prefixIcon: Icon(Icons.school),
                        ),
                        items: app.cohorts.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(
                              '${c.cohortName}${c.isCurrent ? " ⭐" : ""}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() => _cohortId = v);
                          if (_subjectId != null) _load();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Type
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _typeFilter.isEmpty ? null : _typeFilter,
                        decoration: const InputDecoration(
                          labelText: 'ប្រភេទ',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'homework', child: Text('📝 Homework')),
                          DropdownMenuItem(value: 'quiz', child: Text('❓ Quiz')),
                          DropdownMenuItem(value: 'assignment', child: Text('📋 Assignment')),
                        ],
                        onChanged: (v) {
                          setState(() => _typeFilter = v ?? '');
                          if (_subjectId != null) _load();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==================== ACTIONS ====================
          if (_subjectId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'ចំនួន: ${_homeworks.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _load,
                    tooltip: 'ផ្ទុកឡើងវិញ',
                  ),
                ],
              ),
            ),

          // ==================== LIST ====================
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _subjectId == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📭', style: TextStyle(fontSize: 60)),
                            SizedBox(height: 16),
                            Text('សូមជ្រើសមុខវិជ្ជា'),
                          ],
                        ),
                      )
                    : _homeworks.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('📭', style: TextStyle(fontSize: 60)),
                                SizedBox(height: 16),
                                Text('មិនមានកិច្ចការ'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _homeworks.length,
                              itemBuilder: (_, i) => _homeworkCard(_homeworks[i]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  // ==================== HOMEWORK CARD ====================
  Widget _homeworkCard(Map<String, dynamic> h) {
    final type = h['type'] ?? 'homework';
    final isReadonly = h['is_current'] == 0;

    // Colors + Labels តាម Type
    Color color;
    String icon;
    String label;
    switch (type) {
      case 'quiz':
        color = const Color(0xFF8B5CF6);
        icon = '❓';
        label = 'Quiz';
        break;
      case 'assignment':
        color = AppTheme.warning;
        icon = '📋';
        label = 'Assignment';
        break;
      default:
        color = AppTheme.info;
        icon = '📝';
        label = 'Homework';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openDetail(h),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Badge + Readonly
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$icon $label',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isReadonly)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✅ បញ្ចប់',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                h['title'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Cohort
              if (h['cohort_name'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '🎓 ${h['cohort_name']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Description
              if (h['description'] != null && h['description'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    h['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.gray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 10),

              // Meta Info
              Row(
                children: [
                  Expanded(
                    child: _infoChip(
                      Icons.calendar_today,
                      'ផុតកំណត់',
                      h['due_date'] ?? '-',
                    ),
                  ),
                  Expanded(
                    child: _infoChip(
                      Icons.star,
                      'ពិន្ទុពេញ',
                      '${h['max_score']}',
                    ),
                  ),
                  Expanded(
                    child: _infoChip(
                      Icons.check_circle,
                      'ដាក់រួច',
                      '${h['submitted_count'] ?? 0} នាក់',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppTheme.gray),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppTheme.gray),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ==================== LOAD ====================
  Future<void> _load() async {
    if (_subjectId == null) return;

    setState(() => _loading = true);
    try {
      final filters = <String, String>{};
      if (_cohortId != null) filters['cohort_id'] = '$_cohortId';
      if (_typeFilter.isNotEmpty) filters['type'] = _typeFilter;

      final list = await HomeworkService.list(
        subjectId: _subjectId!,
        filters: filters,
      );
      setState(() => _homeworks = list);
    } catch (e) {
      _showSnack('Error: $e', AppTheme.danger);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ==================== NAVIGATION ====================
  Future<void> _openCreateForm() async {
    if (_subjectId == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkFormScreen(
          subjectId: _subjectId!,
          cohortId: _cohortId,
        ),
      ),
    );

    if (result == true) _load();
  }

  Future<void> _openDetail(Map<String, dynamic> h) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkDetailScreen(homework: h),
      ),
    );

    if (result == true) _load();
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}