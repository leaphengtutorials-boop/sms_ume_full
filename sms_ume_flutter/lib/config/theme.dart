import 'package:flutter/material.dart';

/// ============================================================
/// APP THEME — SMS UME
/// ============================================================
/// Colors + ThemeData សម្រាប់ Flutter App ទាំងមូល
/// ============================================================

class AppTheme {
  // ============================================================
  // COLORS
  // ============================================================
  static const Color primary      = Color(0xFF6366F1);
  static const Color primaryDark  = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color success      = Color(0xFF10B981);
  static const Color danger       = Color(0xFFEF4444);
  static const Color warning      = Color(0xFFF59E0B);
  static const Color info         = Color(0xFF3B82F6);
  static const Color dark         = Color(0xFF1E293B);
  static const Color gray         = Color(0xFF64748B);
  static const Color light        = Color(0xFFF1F5F9);
  static const Color border       = Color(0xFFE2E8F0);
  static const Color bg           = Color(0xFFF8FAFC);

  // ============================================================
  // LIGHT THEME
  // ============================================================
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        primaryColor: primary,
        scaffoldBackgroundColor: bg,

        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: primaryDark,
          surface: Colors.white,
          error: danger,
        ),

        fontFamily: 'Kantumruy Pro',

        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),

        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),

        dividerTheme: const DividerThemeData(
          color: border,
          thickness: 1,
          space: 1,
        ),

        chipTheme: ChipThemeData(
          backgroundColor: primaryLight,
          labelStyle: const TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: primary,
        ),
      );

  // ============================================================
  // HELPERS
  // ============================================================
  static Color gradeColor(String grade) {
    switch (grade) {
      case 'A':
        return success;
      case 'B':
        return info;
      case 'C':
        return const Color(0xFF8B5CF6);
      case 'D':
        return warning;
      case 'E':
        return const Color(0xFFF97316);
      case 'F':
        return danger;
      default:
        return gray;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'active':
      case 'present':
        return success;
      case 'graduated':
      case 'permission':
        return info;
      case 'late':
        return warning;
      case 'dropped':
      case 'absent':
        return danger;
      default:
        return gray;
    }
  }

  static String statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'កំពុងរៀន';
      case 'graduated':
        return 'បញ្ចប់';
      case 'dropped':
        return 'ឈប់';
      case 'present':
        return 'មាន';
      case 'late':
        return 'យឺត';
      case 'absent':
        return 'អវត្តមាន';
      case 'permission':
        return 'ច្បាប់';
      default:
        return status;
    }
  }
}