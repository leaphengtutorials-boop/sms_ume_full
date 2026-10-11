import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../services/student_service.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import 'student_form_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _search = '';
  String _statusFilter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👥 សិស្ស')),
      drawer: const MainDrawer(),

      // ✅ Floating Action Button — បន្ថែមសិស្សថ្មី
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('បន្ថែមសិស្ស'),
        backgroundColor: AppTheme.primary,
      ),

      body: Consumer<AppProvider>(
        builder: (context, app, _) {
          if (app.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter
          final filtered = app.students.where((s) {
            // Search
            if (_search.isNotEmpty) {
              final q = _search.toLowerCase();
              final match = s.fullName.toLowerCase().contains(q) ||
                  s.studentCode.toLowerCase().contains(q);
              if (!match) return false;
            }
            // Status
            if (_statusFilter.isNotEmpty && s.status != _statusFilter) {
              return false;
            }
            return true;
          }).toList();

          return Column(
            children: [
              // ==================== SEARCH + FILTER ====================
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    // Search
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '🔍 ស្វែងរក...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => setState(() => _search = v),
                    ),
                    const SizedBox(height: 12),

                    // Status Filter
                    Row(
                      children: [
                        const Icon(Icons.filter_list, color: AppTheme.gray),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _filterChip('ទាំងអស់', ''),
                                _filterChip('🟢 កំពុងរៀន', 'active'),
                                _filterChip('🎓 បញ្ចប់', 'graduated'),
                                _filterChip('🔴 ឈប់', 'dropped'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==================== COUNT ====================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'ចំនួន: ${filtered.length} នាក់',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => app.loadStudents(),
                      tooltip: 'ផ្ទុកឡើងវិញ',
                    ),
                  ],
                ),
              ),

              // ==================== LIST ====================
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('👥', style: TextStyle(fontSize: 60)),
                            SizedBox(height: 16),
                            Text('មិនមានសិស្ស'),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => app.loadStudents(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 80, // បន្ថែមចន្លោះសម្រាប់ FAB
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _studentCard(filtered[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== FILTER CHIP ====================
  Widget _filterChip(String label, String value) {
    final isActive = _statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.gray,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        selected: isActive,
        onSelected: (_) => setState(() => _statusFilter = value),
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive ? AppTheme.primary : AppTheme.border,
          ),
        ),
      ),
    );
  }

  // ==================== STUDENT CARD ====================
  Widget _studentCard(dynamic s) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openForm(student: s),  // ចុចលើ = Edit
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Photo
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryLight,
                child: s.photo != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: '${ApiConfig.uploadUrl}/${s.photo}',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (_, __, ___) =>
                              Text(s.gender == 'M' ? '👨' : '👩'),
                        ),
                      )
                    : Text(
                        s.gender == 'M' ? '👨' : '👩',
                        style: const TextStyle(fontSize: 24),
                      ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '📌 ${s.studentCode}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.gray,
                          ),
                        ),
                        if (s.cohortName != null) ...[
                          const Text(' · ',
                              style: TextStyle(color: AppTheme.gray)),
                          Text(
                            '🎓 ${s.cohortName}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              _statusBadge(s.status),

              // ✅ Popup Menu — Edit / Delete
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.gray),
                onSelected: (action) {
                  if (action == 'edit') _openForm(student: s);
                  if (action == 'delete') _confirmDelete(s);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppTheme.primary, size: 20),
                        SizedBox(width: 8),
                        Text('កែ'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppTheme.danger, size: 20),
                        SizedBox(width: 8),
                        Text('លុប'),
                      ],
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

  // ==================== STATUS BADGE ====================
  Widget _statusBadge(String status) {
    final map = {
      'active': ['កំពុងរៀន', AppTheme.success],
      'graduated': ['បញ្ចប់', AppTheme.info],
      'dropped': ['ឈប់', AppTheme.danger],
    };
    final info = map[status] ?? map['active']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (info[1] as Color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        info[0] as String,
        style: TextStyle(
          color: info[1] as Color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  // ==================== OPEN FORM ====================
  Future<void> _openForm({dynamic student}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(student: student),
      ),
    );

    if (result == true) {
      final app = Provider.of<AppProvider>(context, listen: false);
      await app.loadStudents();
    }
  }

  // ==================== DELETE ====================
  Future<void> _confirmDelete(dynamic s) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('លុបសិស្ស?'),
            content: Text('តើអ្នកចង់លុប "${s.fullName}" មែនទេ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('បោះបង់'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.danger,
                ),
                child: const Text('លុប'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    try {
      final res = await StudentService.remove(s.id);
      if (res == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ លុបជោគជ័យ'),
            backgroundColor: AppTheme.success,
          ),
        );
        final app = Provider.of<AppProvider>(context, listen: false);
        await app.loadStudents();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }
}