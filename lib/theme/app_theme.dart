import 'package:flutter/material.dart';

// ── Theme Provider ───────────────────────────────────────────
class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setDark(bool val) {
    _isDark = val;
    notifyListeners();
  }
}

// ── Color tokens (light & dark) ──────────────────────────────
class AppColors {
  final bool dark;
  const AppColors({this.dark = false});

  // Blue primary — same in both modes
  Color get primary      => const Color(0xFF2196F3);
  Color get primaryDark  => const Color(0xFF1565C0);

  // Backgrounds
  Color get scaffold     => dark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
  Color get surface      => dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get card         => dark ? const Color(0xFF2A2A2A) : Colors.white;
  Color get inputFill    => dark ? const Color(0xFF2C2C2C) : Colors.white;
  Color get divider      => dark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  Color get headerBg     => dark ? const Color(0xFF1565C0) : const Color(0xFF1E88E5);

  // Text
  Color get textPrimary  => dark ? Colors.white        : const Color(0xFF1A1A2E);
  Color get textSecond   => dark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get textHint     => dark ? const Color(0xFF666666) : const Color(0xFFBDBDBD);
  Color get textBlue     => const Color(0xFF2196F3);

  // Status
  Color get normalBg     => dark ? const Color(0xFF1B3A2A) : const Color(0xFFE8F5E9);
  Color get normalText   => const Color(0xFF388E3C);
  Color get warningBg    => dark ? const Color(0xFF3A2E10) : const Color(0xFFFFF8E1);
  Color get warningText  => const Color(0xFFF57F17);
  Color get dangerBg     => dark ? const Color(0xFF3A1515) : const Color(0xFFFFEBEE);
  Color get dangerText   => const Color(0xFFD32F2F);
  Color get infoBg       => dark ? const Color(0xFF0D2137) : const Color(0xFFE3F2FD);
  Color get infoText     => const Color(0xFF1565C0);

  // Alert borders
  Color get alertWarn    => const Color(0xFFFFA726);
  Color get alertOk      => const Color(0xFF4CAF50);
  Color get alertErr     => const Color(0xFFEF5350);
  Color get alertInfo    => const Color(0xFF42A5F5);

  Color get available    => const Color(0xFF4CAF50);
  Color get offline      => const Color(0xFFEF5350);
  Color get chartLine    => const Color(0xFF1976D2);

  // Toggle
  Color get toggleActive => const Color(0xFF2196F3);
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

// ── Dark ThemeData ───────────────────────────────────────────
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2196F3),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
);
