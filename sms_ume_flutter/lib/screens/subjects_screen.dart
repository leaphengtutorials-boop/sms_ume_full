import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/main_drawer.dart';
import '../config/theme.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📚 មុខវិជ្ជា')),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<AppProvider>(
        builder: (context, app, _) {
          if (app.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (app.subjects.isEmpty) {
            return const Center(
              child: Text('📭 មិនមានមុខវិជ្ជា'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: app.subjects.length,
            itemBuilder: (context, i) {
              final s = app.subjects[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    s.subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('${s.subjectCode} · ឆ្នាំ ${s.studyYear} · ឆមាស ${s.semester}'),
                      Text('🗓️ ${s.yearName ?? "-"} · 📆 ${s.totalWeeks} សប្តាហ៍'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${s.studentCount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const Text(
                        'សិស្ស',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('➕ បន្ថែមមុខវិជ្ជា'),
        content: const Text('នឹងបន្ថែម...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('បិទ'),
          ),
        ],
      ),
    );
  }
}