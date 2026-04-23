import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════
//  Shared Preferences Keys
// ═══════════════════════════════════════════════════════
class PrefKeys {
  static const isLoggedIn = 'isLoggedIn';
  static const isDark = 'isDark';
  static const language = 'language';
  static const lastNavIndex = 'lastNavIndex';
}

// ═══════════════════════════════════════════════════════
//  AppState
// ═══════════════════════════════════════════════════════
class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isDark = false;
  String _language = 'en';
  int _lastNavIndex = 0;

  SharedPreferences? _prefs;

  bool get isLoggedIn => _isLoggedIn;
  bool get isDark => _isDark;
  String get language => _language;
  int get lastNavIndex => _lastNavIndex;

  // ── Init SharedPreferences once ──────────────────────
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Load saved data ──────────────────────────────────
  Future<void> load() async {
    _isLoggedIn = _prefs?.getBool(PrefKeys.isLoggedIn) ?? false;
    _isDark = _prefs?.getBool(PrefKeys.isDark) ?? false;
    _language = _prefs?.getString(PrefKeys.language) ?? 'en';
    _lastNavIndex = _prefs?.getInt(PrefKeys.lastNavIndex) ?? 0;
    notifyListeners();
  }

  // ── Auth ─────────────────────────────────────────────
  Future<void> login() async {
    _isLoggedIn = true;
    _lastNavIndex = 0;
    await _prefs?.setBool(PrefKeys.isLoggedIn, true);
    await _prefs?.setInt(PrefKeys.lastNavIndex, 0);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _lastNavIndex = 0;
    await _prefs?.setBool(PrefKeys.isLoggedIn, false);
    await _prefs?.setInt(PrefKeys.lastNavIndex, 0);
    notifyListeners();
  }

  // ── Theme ─────────────────────────────────────────────
  Future<void> setDark(bool val) async {
    _isDark = val;
    await _prefs?.setBool(PrefKeys.isDark, val);
    notifyListeners();
  }

  // ── Language ──────────────────────────────────────────
  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _prefs?.setString(PrefKeys.language, lang);
    notifyListeners();
  }

  // ── Bottom Nav ────────────────────────────────────────
  Future<void> setNavIndex(int i) async {
    _lastNavIndex = i;
    await _prefs?.setInt(PrefKeys.lastNavIndex, i);
    notifyListeners();
  }
}
