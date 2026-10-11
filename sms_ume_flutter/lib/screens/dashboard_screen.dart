import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/stat_card.dart';
import '../config/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📊 ផ្ទាំងគ្រប់គ្រង')),
      drawer: const MainDrawer(),
      body: Consumer<AppProvider>(
        builder: (context, app, _) {
          if (app.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: app.loadAll,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ✅ Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    StatCard(
                      icon: '👥',
                      value: app.activeStudentsCount.toString(),
                      label: 'សិស្សកំពុងរៀន',
                      color: AppTheme.primary,
                    ),
                    StatCard(
                      icon: '📚',
                      value: app.subjects.length.toString(),
                      label: 'មុខវិជ្ជា',
                      color: AppTheme.success,
                    ),
                    StatCard(
                      icon: '📅',
                      value: app.years.length.toString(),
                      label: 'ឆ្នាំ',
                      color: AppTheme.warning,
                    ),
                    StatCard(
                      icon: '🎓',
                      value: app.graduatedStudentsCount.toString(),
                      label: 'បញ្ចប់',
                      color: AppTheme.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ✅ Active Subjects
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📚 មុខវិជ្ជាសកម្ម',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...app.subjects.take(5).map((s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.subjectName),
                              subtitle: Text('${s.subjectCode} · ${s.totalWeeks} សប្តាហ៍'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${s.studentCount} សិស្ស',
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}