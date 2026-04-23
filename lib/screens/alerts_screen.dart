import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

enum _Filter { all, health, system }

enum _AType { warning, success, danger, info }

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  _Filter _filter = _Filter.all;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading — هيتبدل بـ API call مع الباك اند
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  final List<_Alert> _items = [
    _Alert(
        _AType.warning,
        'Elevated Temperature',
        'Your temperature reading of 37.8°C is slightly above normal.',
        'Today, 11:20 AM',
        'Monitor and rest',
        _Filter.health),
    _Alert(
        _AType.success,
        'Heart Rate Normal',
        'Your heart rate is within the healthy range (72 bpm).',
        'Today, 10:32 AM',
        null,
        _Filter.health),
    _Alert(
        _AType.info,
        'Machine Sync Complete',
        'Your vitals have been synced with Machine #MH-042.',
        'Today, 10:30 AM',
        null,
        _Filter.system),
    _Alert(
        _AType.danger,
        'Low SpO₂ Detected',
        'SpO₂ reading of 93% detected. Please consult a healthcare provider.',
        'Yesterday, 3:15 PM',
        'Seek medical advice',
        _Filter.health),
    _Alert(
        _AType.warning,
        'Machine Offline',
        'Machine #MH-018 at Central Park is currently offline.',
        'Yesterday, 1:00 PM',
        null,
        _Filter.system),
    _Alert(
        _AType.info,
        'Profile Updated',
        'Your health profile was successfully updated.',
        '2 days ago',
        null,
        _Filter.system),
  ];

  List<_Alert> get _shown => _filter == _Filter.all
      ? _items
      : _items.where((a) => a.cat == _filter).toList();

  void _dismiss(_Alert alert) {
    setState(() => _items.remove(alert));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shown = _shown;
    return Scaffold(
      body: Column(children: [
        BlueHeader(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Alerts',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text('${_items.length} active notifications',
                style: const TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 14),
            Row(children: [
              _fBtn('All', _Filter.all),
              const SizedBox(width: 8),
              _fBtn('Health Alerts', _Filter.health),
              const SizedBox(width: 8),
              _fBtn('System Alerts', _Filter.system),
            ]),
          ]),
        )),
        Expanded(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                      color: c.primary, strokeWidth: 3),
                )
              : shown.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: c.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.notifications_off_outlined,
                                size: 36, color: c.textSecond),
                          ),
                          const SizedBox(height: 14),
                          Text('No alerts',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary)),
                          const SizedBox(height: 6),
                          Text('You\'re all caught up!',
                              style:
                                  TextStyle(fontSize: 13, color: c.textSecond)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: shown.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _AlertCard(
                        item: shown[i],
                        onDismiss: () => _dismiss(shown[i]),
                      ),
                    ),
        ),
      ]),
    );
  }

  Widget _fBtn(String label, _Filter f) {
    final sel = _filter == f;
    return GestureDetector(
      onTap: () => setState(() => _filter = f),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? Colors.transparent : Colors.white54),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                color: sel ? const Color(0xFF2196F3) : Colors.white)),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final _Alert item;
  final VoidCallback onDismiss;
  const _AlertCard({super.key, required this.item, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color border, iconBg, iconColor;
    IconData iconData;
    switch (item.type) {
      case _AType.warning:
        border = c.alertWarn;
        iconBg = c.warningBg;
        iconColor = c.alertWarn;
        iconData = Icons.warning_amber_rounded;
      case _AType.success:
        border = c.alertOk;
        iconBg = c.normalBg;
        iconColor = c.alertOk;
        iconData = Icons.check_circle_outline_rounded;
      case _AType.danger:
        border = c.alertErr;
        iconBg = c.dangerBg;
        iconColor = c.alertErr;
        iconData = Icons.cancel_outlined;
      case _AType.info:
        border = c.alertInfo;
        iconBg = c.infoBg;
        iconColor = c.alertInfo;
        iconData = Icons.info_outline_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: border, width: 4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(iconData, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary)),
          const SizedBox(height: 4),
          Text(item.msg,
              style: TextStyle(fontSize: 13, color: c.textSecond, height: 1.4)),
          const SizedBox(height: 6),
          Text(item.time, style: TextStyle(fontSize: 12, color: c.textHint)),
          if (item.action != null) ...[
            const SizedBox(height: 6),
            Text(item.action!,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: iconColor)),
          ],
        ])),
        // ✅ X button now works
        GestureDetector(
          onTap: onDismiss,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.close, size: 18, color: c.textHint),
          ),
        ),
      ]),
    );
  }
}

class _Alert {
  final _AType type;
  final String title, msg, time;
  final String? action;
  final _Filter cat;
  const _Alert(
      this.type, this.title, this.msg, this.time, this.action, this.cat);
}
