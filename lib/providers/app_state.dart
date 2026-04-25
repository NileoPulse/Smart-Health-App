import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════
//  Shared Preferences Keys
// ═══════════════════════════════════════════════════════
class PrefKeys {
  // ── App-level ─────────────────────────────────────────
  static const isLoggedIn = 'isLoggedIn';
  static const isDark = 'isDark';
  static const language = 'language';
  static const lastNavIndex = 'lastNavIndex';

  // ── Profile ────────────────────────────────────────
  
  static const profileName = 'profile_name';
  static const profileEmail = 'profile_email';
  static const profilePhone = 'profile_phone';
  static const profileDob = 'profile_dob';
  static const profileGender = 'profile_gender';
  static const profileEmergName = 'profile_emerg_name';
  static const profileEmergPhone = 'profile_emerg_phone';

  // ── Smart Card ────────────────────────────────────────
  
  static const isRequestPending = 'isRequestPending';
  static const isCardBlocked = 'isCardBlocked';
  static const requestDate = 'requestDate';
  static const replacementDate = 'replacementDate';



  static const List<String> userKeys = [
    profileName,
    profileEmail,
    profilePhone,
    profileDob,
    profileGender,
    profileEmergName,
    profileEmergPhone,
    isRequestPending,
    isCardBlocked,
    requestDate,
    replacementDate,
    
  ];
}

// ═══════════════════════════════════════════════════════
//  Chat Message Model
// ═══════════════════════════════════════════════════════
class ChatMessage {
  final String text;
  final bool isBot;
  const ChatMessage(this.text, {required this.isBot});
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

  // ── Chat History ──────────────────────────────────────
  final List<ChatMessage> _chatHistory = [
    const ChatMessage(
      "Hi! I'm your SmartHealth assistant 👋\nHow can I help you today?",
      isBot: true,
    ),
  ];

  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  void addChatMessage(ChatMessage message) {
    _chatHistory.add(message);
    notifyListeners();
  }

  void clearChat() {
    _chatHistory
      ..clear()
      ..add(const ChatMessage(
        "Hi! I'm your SmartHealth assistant 👋\nHow can I help you today?",
        isBot: true,
      ));
    notifyListeners();
  }

  // ── Init ─────────────────────────────────────────────
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Load ─────────────────────────────────────────────
  Future<void> load() async {
    _isLoggedIn = _prefs?.getBool(PrefKeys.isLoggedIn) ?? false;
    _isDark = _prefs?.getBool(PrefKeys.isDark) ?? false;
    _language = _prefs?.getString(PrefKeys.language) ?? 'en';
    _lastNavIndex = _prefs?.getInt(PrefKeys.lastNavIndex) ?? 0;
    notifyListeners();
  }

  // ── Login ────────────────────────────────────────────
  Future<void> login() async {
    _isLoggedIn = true;
    _lastNavIndex = 0;
    await _prefs?.setBool(PrefKeys.isLoggedIn, true);
    await _prefs?.setInt(PrefKeys.lastNavIndex, 0);
    notifyListeners();
  }

  // ── Logout ───────────────────────────────────────────

  Future<void> logout() async {
    // 1. Memory reset
    _isLoggedIn = false;
    _lastNavIndex = 0;
    clearChat(); 

    if (_prefs != null) {
      for (final key in PrefKeys.userKeys) {
        await _prefs!.remove(key);
      }
    }

    // 3. Auth flag
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
