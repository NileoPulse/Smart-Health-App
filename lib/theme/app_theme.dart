import 'package:flutter/material.dart';

// ── Color tokens (light & dark) ──────────────────────────────
class AppColors {
  final bool dark;
  const AppColors({this.dark = false});

  // ── Primary Blue ────────────────────────────────────────────

  Color get primary => dark ? const Color(0xFF5BA4E5) : const Color(0xFF2196F3);
  Color get primaryDark =>
      dark ? const Color(0xFF3A7DC4) : const Color(0xFF1565C0);

  // ── Backgrounds (Elevation System) ──────────────────────────

  Color get scaffold =>
      dark ? const Color(0xFF121214) : const Color(0xFFF5F7FA);

  Color get surface => dark ? const Color(0xFF1C1C1F) : Colors.white;

  Color get card => dark ? const Color(0xFF252528) : Colors.white;

  Color get inputFill => dark ? const Color(0xFF2E2E32) : Colors.white;

  Color get divider => dark ? const Color(0xFF38383C) : const Color(0xFFE0E0E0);
  Color get headerBg =>
      dark ? const Color(0xFF1A3A5C) : const Color(0xFF1E88E5);

  Color get textPrimary =>
      dark ? const Color(0xFFE8E8EA) : const Color(0xFF1A1A2E);

  Color get textSecond =>
      dark ? const Color(0xFF9A9A9E) : const Color(0xFF757575);

  Color get textHint =>
      dark ? const Color(0xFF5C5C60) : const Color(0xFFBDBDBD);
  Color get textBlue =>
      dark ? const Color(0xFF5BA4E5) : const Color(0xFF2196F3);

  Color get normalBg =>
      dark ? const Color(0xFF1A2D22) : const Color(0xFFE8F5E9);
  Color get normalText =>
      dark ? const Color(0xFF6DBF85) : const Color(0xFF388E3C);

  Color get warningBg =>
      dark ? const Color(0xFF2C2415) : const Color(0xFFFFF8E1);
  Color get warningText =>
      dark ? const Color(0xFFD4A847) : const Color(0xFFF57F17);

  Color get dangerBg =>
      dark ? const Color(0xFF2A1A1A) : const Color(0xFFFFEBEE);
  Color get dangerText =>
      dark ? const Color(0xFFCF7070) : const Color(0xFFD32F2F);

  Color get infoBg => dark ? const Color(0xFF152233) : const Color(0xFFE3F2FD);
  Color get infoText =>
      dark ? const Color(0xFF5B9BD5) : const Color(0xFF1565C0);

  Color get alertWarn =>
      dark ? const Color(0xFFB8922A) : const Color(0xFFFFA726);
  Color get alertOk => dark ? const Color(0xFF4A9E5E) : const Color(0xFF4CAF50);
  Color get alertErr =>
      dark ? const Color(0xFFB85555) : const Color(0xFFEF5350);
  Color get alertInfo =>
      dark ? const Color(0xFF4A85B8) : const Color(0xFF42A5F5);

  // ── Indicators ───────────────────────────────────────────────
  Color get available =>
      dark ? const Color(0xFF4A9E5E) : const Color(0xFF4CAF50);
  Color get offline => dark ? const Color(0xFFB85555) : const Color(0xFFEF5350);
  Color get chartLine =>
      dark ? const Color(0xFF4A85C8) : const Color(0xFF1976D2);

  // ── Toggle ───────────────────────────────────────────────────
  Color get toggleActive =>
      dark ? const Color(0xFF5BA4E5) : const Color(0xFF2196F3);
}

extension AppColorsContext on BuildContext {
  AppColors get colors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return AppColors(dark: isDark);
  }
}

// ── Light ThemeData ──────────────────────────────────────────
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1A1A2E),
    elevation: 0,
  ),
);

// ── Dark ThemeData ───────────────────────────
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF5BA4E5),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121214),
  cardColor: const Color(0xFF252528),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1C1C1F),
    foregroundColor: Color(0xFFE8E8EA),
    elevation: 0,
  ),
);
