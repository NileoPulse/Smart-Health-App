import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';

// extra_screens.dart بيضم: EmergencyQrScreen, RequestSmartCardScreen,
// ReportLostCardScreen — بنديه alias عشان نفصله عن
// support_chat_screen.dart اللي فيه نسخة قديمة بنفس الاسم.
import 'extra_screens.dart' as extra;

// دي النسخة الذكية اللي بتستخدم AppState.chatHistory
import 'support_chat_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _notifications = true;

  void _showLanguagePicker(BuildContext context) {
    final c = context.colors;
    final appState = context.read<AppState>();
    final langs = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸', 'sub': 'English'},
      {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦', 'sub': 'العربية'},
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: c.divider, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Text('Select Language',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary)),
          const SizedBox(height: 12),
          ...langs.map((lang) {
            final selected = appState.language == lang['code'];
            return InkWell(
              onTap: () {
                appState.setLanguage(lang['code']!);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color:
                      selected ? c.primary.withValues(alpha: 0.08) : c.scaffold,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? c.primary : c.divider,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(children: [
                  Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang['name']!,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: c.textPrimary)),
                        Text(lang['sub']!,
                            style:
                                TextStyle(fontSize: 12, color: c.textSecond)),
                      ]),
                  const Spacer(),
                  if (selected)
                    Icon(Icons.check_circle_rounded,
                        color: c.primary, size: 22),
                ]),
              ),
            );
          }),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: c.scaffold,
      body: SingleChildScrollView(
        child: Column(children: [
          BlueHeader(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('More',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Settings & information',
                        style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _ProfileCard(c: c),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Settings',
                c: c,
                children: [
                  _SettingRow(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    toggle: _notifications,
                    onToggle: (v) => setState(() => _notifications = v),
                  ),
                  _SettingRow(
                    icon: Icons.translate_outlined,
                    label: 'Language',
                    showArrow: true,
                    trailing: Text(
                      appState.language == 'ar'
                          ? '🇸🇦 Arabic'
                          : '🇺🇸 English',
                      style: TextStyle(fontSize: 13, color: c.textSecond),
                    ),
                    onTap: () => _showLanguagePicker(context),
                  ),
                  _SettingRow(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    toggle: appState.isDark,
                    onToggle: (v) => appState.setDark(v),
                    last: true,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Smart Card',
                c: c,
                children: [
                  _ArrowRow(
                    icon: Icons.credit_card_outlined,
                    label: 'Smart Card Services',
                    subtitle: 'Request or report your card',
                    c: c,
                    last: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SmartCardServicesScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Reports',
                c: c,
                children: [
                  _ArrowRow(
                    icon: Icons.history_edu_outlined,
                    label: 'Reports History',
                    subtitle: 'View & share previous reports',
                    c: c,
                    last: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportsHistoryScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Support',
                c: c,
                children: [
                  _ArrowRow(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Support Chat',
                    subtitle: 'Chat with health assistant',
                    c: c,
                    last: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SupportChatScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AppState>().logout();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  },
                  icon: Icon(Icons.logout_rounded, color: c.alertErr, size: 20),
                  label: Text('Logout',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: c.alertErr)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: c.alertErr),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SMART CARD SERVICES SCREEN
// ══════════════════════════════════════════════════════════════
class SmartCardServicesScreen extends StatefulWidget {
  const SmartCardServicesScreen({super.key});
  @override
  State<SmartCardServicesScreen> createState() =>
      _SmartCardServicesScreenState();
}

class _SmartCardServicesScreenState extends State<SmartCardServicesScreen> {
  bool _isRequestPending = false;
  bool _isCardBlocked = false;
  DateTime? _requestDate;
  DateTime? _replacementDate;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final reqDateStr = prefs.getString(PrefKeys.requestDate);
    final repDateStr = prefs.getString(PrefKeys.replacementDate);
    setState(() {
      _isRequestPending = prefs.getBool(PrefKeys.isRequestPending) ?? false;
      _isCardBlocked = prefs.getBool(PrefKeys.isCardBlocked) ?? false;
      _requestDate = reqDateStr != null ? DateTime.tryParse(reqDateStr) : null;
      _replacementDate =
          repDateStr != null ? DateTime.tryParse(repDateStr) : null;
    });
  }

  int _daysLeft(DateTime? from, int totalDays) {
    if (from == null) return totalDays;
    final diff = totalDays - DateTime.now().difference(from).inDays;
    return diff < 0 ? 0 : diff;
  }

  Future<void> _onRequestDone() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setBool(PrefKeys.isRequestPending, true);
    await prefs.setString(PrefKeys.requestDate, now.toIso8601String());
    setState(() {
      _isRequestPending = true;
      _requestDate = now;
    });
  }

  Future<void> _onLostDone() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setBool(PrefKeys.isCardBlocked, true);
    await prefs.setBool(PrefKeys.isRequestPending, true);
    await prefs.setString(PrefKeys.replacementDate, now.toIso8601String());
    setState(() {
      _isCardBlocked = true;
      _isRequestPending = true;
      _replacementDate = now;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final reqDaysLeft = _daysLeft(_requestDate, 7);
    final repDaysLeft = _daysLeft(_replacementDate, 7);

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        title: Text('Smart Card Services',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: c.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.credit_card_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 12),
              const Text('Smart Card Services',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Manage your SmartHealth card',
                  style: TextStyle(fontSize: 13, color: Colors.white70)),
              if (_isCardBlocked || _isRequestPending) ...[
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isCardBlocked
                        ? const Color(0xFFEF5350).withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isCardBlocked
                          ? const Color(0xFFEF5350)
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      _isCardBlocked
                          ? Icons.block_rounded
                          : Icons.hourglass_top_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isCardBlocked ? 'Card Blocked' : 'Request Pending',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 20),

          // ✅ Request Smart Card - result check
          _SmartCardTile(
            key: ValueKey('request_$_isRequestPending'),
            icon: Icons.add_card_outlined,
            iconBg: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1976D2),
            title: 'Request Smart Card',
            subtitle:
                'Apply for a new SmartHealth card for faster kiosk access',
            isPending: _isRequestPending && !_isCardBlocked,
            isBlocked: false,
            daysLeft: reqDaysLeft,
            buttonLabel: 'Request Now',
            buttonColor: const Color(0xFF2196F3),
            onTap: _isRequestPending && !_isCardBlocked
                ? null
                : () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const extra.RequestSmartCardScreen()),
                    );
                    if (result == true) {
                      final now = DateTime.now();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(PrefKeys.isRequestPending, true);
                      await prefs.setString(
                          PrefKeys.requestDate, now.toIso8601String());
                      if (mounted) {
                        setState(() {
                          _isRequestPending = true;
                          _requestDate = now;
                        });
                      }
                    }
                  },
          ),
          const SizedBox(height: 14),

          // ✅ Report Lost Card - result check
          _SmartCardTile(
            key: ValueKey('lost_$_isCardBlocked'),
            icon: Icons.credit_card_off_outlined,
            iconBg: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFEF5350),
            title: 'Report Lost Card',
            subtitle:
                'Block your lost card immediately to protect your health data',
            isPending: _isCardBlocked,
            isBlocked: _isCardBlocked,
            daysLeft: repDaysLeft,
            buttonLabel: 'Report Lost',
            buttonColor: const Color(0xFFEF5350),
            onTap: _isCardBlocked
                ? null
                : () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const extra.ReportLostCardScreen()),
                    );
                    if (result == true) {
                      final now = DateTime.now();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(PrefKeys.isCardBlocked, true);
                      await prefs.setBool(PrefKeys.isRequestPending, true);
                      await prefs.setString(
                          PrefKeys.replacementDate, now.toIso8601String());
                      if (mounted) {
                        setState(() {
                          _isCardBlocked = true;
                          _isRequestPending = true;
                          _replacementDate = now;
                        });
                      }
                    }
                  },
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _SmartCardTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle, buttonLabel;
  final Color buttonColor;
  final bool isPending, isBlocked;
  final int daysLeft;
  final VoidCallback? onTap;

  _SmartCardTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isPending,
    required this.isBlocked,
    required this.daysLeft,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBlocked
              ? const Color(0xFFEF5350).withValues(alpha: 0.4)
              : isPending
                  ? const Color(0xFF2196F3).withValues(alpha: 0.4)
                  : c.divider,
          width: isPending || isBlocked ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12, color: c.textSecond, height: 1.4)),
            ]),
          ),
        ]),
        if (isPending) ...[
          const SizedBox(height: 16),
          Row(children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(
                  value: daysLeft / 7,
                  strokeWidth: 5,
                  backgroundColor: c.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(isBlocked
                      ? const Color(0xFFEF5350)
                      : const Color(0xFF2196F3)),
                ),
                Text('$daysLeft\ndays',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                        height: 1.2)),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBlocked ? 'Card Blocked' : 'Request Submitted',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isBlocked
                              ? const Color(0xFFEF5350)
                              : const Color(0xFF2196F3)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      daysLeft == 0
                          ? 'Your card should arrive soon!'
                          : isBlocked
                              ? 'Replacement arrives in ~$daysLeft days'
                              : 'Estimated delivery in ~$daysLeft days',
                      style: TextStyle(
                          fontSize: 12, color: c.textSecond, height: 1.4),
                    ),
                  ]),
            ),
          ]),
        ],
        if (!isPending) ...[
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
              child: Text(buttonLabel,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ]),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle, buttonLabel;
  final Color buttonColor;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
    this.buttonColor = const Color(0xFF2196F3),
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary))),
        ]),
        const SizedBox(height: 10),
        Text(subtitle,
            style: TextStyle(fontSize: 13, color: c.textSecond, height: 1.4)),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
            ),
            child: Text(buttonLabel,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  REPORTS HISTORY SCREEN
// ══════════════════════════════════════════════════════════════
class ReportsHistoryScreen extends StatelessWidget {
  const ReportsHistoryScreen({super.key});

  static final _reports = [
    _Report('Full Health Report', 'Today, 10:32 AM', 'Central Health Hub', 82,
        'Excellent'),
    _Report('Vitals Summary', 'Yesterday, 2:15 PM', 'East Mall Station', 78,
        'Good'),
    _Report('Full Health Report', 'Mar 19, 9:00 AM', 'North Community Center',
        88, 'Excellent'),
    _Report(
        'Vitals Summary', 'Mar 15, 11:45 AM', 'Central Health Hub', 65, 'Good'),
    _Report('Full Health Report', 'Mar 10, 4:00 PM', 'Westside Clinic Kiosk',
        50, 'Needs Attention'),
    _Report('Vitals Summary', 'Mar 1, 8:30 AM', 'East Mall Station', 85,
        'Excellent'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        title: Text('Reports History',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: c.divider),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ReportCard(report: _reports[i]),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _Report report;
  const _ReportCard({required this.report});

  Color get _scoreColor {
    if (report.score >= 80) return const Color(0xFF4CAF50);
    if (report.score >= 60) return const Color(0xFFFFA726);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _scoreColor, width: 2.5),
          ),
          child: Center(
            child: Text('${report.score}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _scoreColor)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(report.title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 3),
            Text(report.date,
                style: TextStyle(fontSize: 12, color: c.textSecond)),
            const SizedBox(height: 2),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 12, color: c.textHint),
              const SizedBox(width: 3),
              Expanded(
                  child: Text(report.machine,
                      style: TextStyle(fontSize: 11, color: c.textHint),
                      overflow: TextOverflow.ellipsis)),
            ]),
          ]),
        ),
        IconButton(
          onPressed: () => _share(context, report),
          icon: Icon(Icons.share_outlined, color: c.primary, size: 22),
          tooltip: 'Share Report',
        ),
      ]),
    );
  }

  void _share(BuildContext context, _Report report) {
    Share.share(
      '🏥 SmartHealth Report\n'
      '📋 ${report.title}\n'
      '📅 ${report.date}\n'
      '📍 ${report.machine}\n\n'
      '⭐ Health Score: ${report.score} / 100 — ${report.status}\n\n'
      'Generated by SmartHealth App 💙',
      subject: 'SmartHealth — ${report.title}',
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════════
class _ProfileCard extends StatelessWidget {
  final AppColors c;
  const _ProfileCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                width: 2),
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: Color(0xFF2196F3), size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Alex Johnson',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 3),
            Text('Member since Jan 2024',
                style: TextStyle(fontSize: 12, color: c.textSecond)),
            const SizedBox(height: 3),
            Row(children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text('Active Account',
                  style: TextStyle(fontSize: 11, color: c.textSecond)),
            ]),
          ]),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Edit',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2196F3))),
          ),
        ),
      ]),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final AppColors c;

  const _SectionCard(
      {required this.title, required this.children, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: c.textHint,
                  letterSpacing: 0.6)),
        ),
        Divider(height: 1, color: c.divider),
        ...children,
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final AppColors c;
  final bool last;
  final VoidCallback? onTap;

  const _ArrowRow({
    required this.icon,
    required this.label,
    required this.c,
    this.subtitle,
    this.last = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: last
            ? const BorderRadius.vertical(bottom: Radius.circular(14))
            : BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: c.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 15,
                            color: c.textPrimary,
                            fontWeight: FontWeight.w500)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!,
                          style: TextStyle(fontSize: 12, color: c.textSecond)),
                    ],
                  ]),
            ),
            Icon(Icons.chevron_right, color: c.textHint),
          ]),
        ),
      ),
      if (!last)
        Divider(height: 1, color: c.divider, indent: 16, endIndent: 16),
    ]);
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final bool showArrow;
  final bool last;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.toggle,
    this.onToggle,
    this.showArrow = false,
    this.last = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: c.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: c.textPrimary)),
            ),
            if (trailing != null) trailing!,
            if (toggle != null)
              Switch(
                value: toggle!,
                onChanged: onToggle,
                thumbColor: WidgetStateProperty.all(Colors.white),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return c.primary;
                  return c.divider;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            else if (showArrow)
              Icon(Icons.chevron_right, color: c.textHint, size: 20),
          ]),
        ),
      ),
      if (!last)
        Divider(height: 1, color: c.divider, indent: 64, endIndent: 16),
    ]);
  }
}

class _Report {
  final String title, date, machine, status;
  final int score;
  const _Report(this.title, this.date, this.machine, this.score, this.status);
}
