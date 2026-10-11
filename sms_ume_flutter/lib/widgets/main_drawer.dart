import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/subjects_screen.dart';
import '../screens/students_screen.dart';
import '../screens/enrollment_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/homework_screen.dart';
import '../screens/scores_screen.dart';
import '../screens/final_scores_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('📚', style: TextStyle(fontSize: 40)),
                SizedBox(height: 8),
                Text(
                  'គ្រប់គ្រងសិស្ស',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Student Management',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _item(context, '📊', 'ផ្ទាំងគ្រប់គ្រង', const DashboardScreen()),
          _item(context, '📚', 'មុខវិជ្ជា', const SubjectsScreen()),
          _item(context, '👥', 'សិស្ស', const StudentsScreen()),
          _item(context, '📝', 'ចុះឈ្មោះចូលរៀន', const EnrollmentScreen()),
          _item(context, '✅', 'វត្តមាន', const AttendanceScreen()),
          _item(context, '📋', 'កិច្ចការ', const HomeworkScreen()),
          _item(context, '📝', 'ពិន្ទុ Midterm', const ScoresScreen()),
          _item(context, '🎓', 'ពិន្ទុ Final', const FinalScoresScreen()),
          _item(context, '📈', 'លទ្ធផល', const ReportsScreen()),
          const Divider(),
          _item(context, '⚙️', 'ការកំណត់', const SettingsScreen()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String icon, String title, Widget screen) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }
}