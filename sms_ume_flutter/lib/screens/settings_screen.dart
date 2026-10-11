import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ ការកំណត់')),
      drawer: const MainDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            context,
            icon: '📅',
            title: 'ឆ្នាំសិក្សា (${app.years.length})',
            subtitle: 'គ្រប់គ្រងឆ្នាំសិក្សា',
            onTap: () => _showYears(context),
          ),
          const SizedBox(height: 8),
          _sectionCard(
            context,
            icon: '🎓',
            title: 'ជំនាន់ (${app.cohorts.length})',
            subtitle: 'គ្រប់គ្រងជំនាន់',
            onTap: () => _showCohorts(context),
          ),
          const SizedBox(height: 8),
          _sectionCard(
            context,
            icon: '📚',
            title: 'មុខវិជ្ជា (${app.subjects.length})',
            subtitle: 'គ្រប់គ្រងមុខវិជ្ជា',
            onTap: () => _showSubjects(context),
          ),
          const SizedBox(height: 8),
          _sectionCard(
            context,
            icon: '🚪',
            title: 'ចាកចេញ',
            subtitle: 'Logout',
            color: AppTheme.danger,
            onTap: () => _logout(context),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Column(
              children: [
                Text(
                  'SMS UME v1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '© 2026 Student Management',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showYears(BuildContext context) {
    final app = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _listSheet(
        sheetContext,
        title: '📅 ឆ្នាំសិក្សា',
        items: app.years
            .map((y) => ListTile(
                  leading: const Text('📅', style: TextStyle(fontSize: 20)),
                  title: Text(y.yearName),
                  trailing: y.isActive
                      ? const Icon(Icons.check, color: AppTheme.success)
                      : null,
                ))
            .toList(),
      ),
    );
  }

  void _showCohorts(BuildContext context) {
    final app = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _listSheet(
        sheetContext,
        title: '🎓 ជំនាន់',
        items: app.cohorts
            .map((c) => ListTile(
                  leading: const Text('🎓', style: TextStyle(fontSize: 20)),
                  title: Text(c.cohortName),
                  trailing: c.isCurrent
                      ? const Icon(Icons.star, color: AppTheme.warning)
                      : null,
                ))
            .toList(),
      ),
    );
  }

  void _showSubjects(BuildContext context) {
    final app = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _listSheet(
        sheetContext,
        title: '📚 មុខវិជ្ជា',
        items: app.subjects
            .map((s) => ListTile(
                  leading: const Text('📚', style: TextStyle(fontSize: 20)),
                  title: Text(s.subjectName),
                  subtitle: Text(s.subjectCode),
                  trailing: Text(
                    '${s.studentCount} សិស្ស',
                    style: const TextStyle(fontSize: 12),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ✅ ដំណោះស្រាយ — ប្រើ sheetContext
  Widget _listSheet(
    BuildContext sheetContext, {
    required String title,
    required List<Widget> items,
  }) {
    final screenHeight = MediaQuery.of(sheetContext).size.height;

    return SizedBox(
      height: screenHeight * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Expanded(
            child: ListView(children: items),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('ចាកចេញ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('បោះបង់'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('ចាកចេញ'),
              ),
            ],
          ),
        ) ??
        false;

    if (ok && context.mounted) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.logout();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }
}