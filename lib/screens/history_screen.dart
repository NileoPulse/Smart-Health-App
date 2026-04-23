import 'package:flutter/material.dart';
import 'session_report_screen.dart';

const _kBlue = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
const _kBg = Color(0xFFF5F7FA);
const _kCard = Colors.white;
const _kBorder = Color(0xFFE0E0E0);
const _kTextDark = Color(0xFF1A1A2E);
const _kTextGrey = Color(0xFF757575);
const _kGreen = Color(0xFF4CAF50);
const _kOrange = Color(0xFFFFA726);
const _kRed = Color(0xFFEF5350);

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _filterIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading — هيتبدل بـ API call مع الباك اند
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  static const _filters = ['7 Days', 'Month', 'All'];

  final _allSessions = [
    _Session(
      id: '001',
      date: 'Today',
      time: '10:32 AM',
      machine: 'Central Health Hub',
      bp: '120/80',
      sugar: '98',
      pulse: '72',
      temp: '36.5',
      spo2: '98',
      score: 82,
      status: _SessionStatus.normal,
      daysAgo: 0,
    ),
    _Session(
      id: '002',
      date: 'Yesterday',
      time: '2:15 PM',
      machine: 'East Mall Station',
      bp: '125/82',
      sugar: '105',
      pulse: '75',
      temp: '36.8',
      spo2: '97',
      score: 78,
      status: _SessionStatus.warning,
      daysAgo: 1,
    ),
    _Session(
      id: '003',
      date: 'Mar 19',
      time: '9:00 AM',
      machine: 'North Community Center',
      bp: '118/76',
      sugar: '92',
      pulse: '68',
      temp: '36.4',
      spo2: '99',
      score: 88,
      status: _SessionStatus.normal,
      daysAgo: 2,
    ),
    _Session(
      id: '004',
      date: 'Mar 15',
      time: '11:45 AM',
      machine: 'Central Health Hub',
      bp: '132/88',
      sugar: '118',
      pulse: '82',
      temp: '37.1',
      spo2: '96',
      score: 65,
      status: _SessionStatus.warning,
      daysAgo: 6,
    ),
    _Session(
      id: '005',
      date: 'Mar 10',
      time: '4:00 PM',
      machine: 'Westside Clinic Kiosk',
      bp: '145/95',
      sugar: '130',
      pulse: '90',
      temp: '37.4',
      spo2: '95',
      score: 50,
      status: _SessionStatus.danger,
      daysAgo: 11,
    ),
    _Session(
      id: '006',
      date: 'Mar 1',
      time: '8:30 AM',
      machine: 'East Mall Station',
      bp: '119/78',
      sugar: '96',
      pulse: '70',
      temp: '36.6',
      spo2: '98',
      score: 85,
      status: _SessionStatus.normal,
      daysAgo: 20,
    ),
  ];

  List<_Session> get _filtered {
    switch (_filterIndex) {
      case 0:
        return _allSessions.where((s) => s.daysAgo <= 7).toList();
      case 1:
        return _allSessions.where((s) => s.daysAgo <= 30).toList();
      default:
        return _allSessions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _filtered;
    return Scaffold(
      backgroundColor: _kBg,
      body: Column(children: [
        // ── Blue Header ──────────────────────────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_kBlueDark, _kBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text('Session History',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ]),
                  const SizedBox(height: 16),

                  // Filter chips
                  Row(
                      children: List.generate(_filters.length, (i) {
                    final sel = _filterIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filterIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? Colors.white : Colors.white54,
                            ),
                          ),
                          child: Text(_filters[i],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? _kBlue : Colors.white)),
                        ),
                      ),
                    );
                  })),
                ],
              ),
            ),
          ),
        ),

        // ── Session Count ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Row(children: [
            Text('${sessions.length} sessions found',
                style: const TextStyle(fontSize: 13, color: _kTextGrey)),
          ]),
        ),

        // ── List ─────────────────────────────────────────────
        Expanded(
          child: _loading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: _kBlue, strokeWidth: 3),
                )
              : sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: _kBlue.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history_outlined,
                                size: 36, color: _kTextGrey),
                          ),
                          const SizedBox(height: 14),
                          const Text('No sessions found',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _kTextDark)),
                          const SizedBox(height: 6),
                          const Text('No sessions in this period',
                              style:
                                  TextStyle(fontSize: 13, color: _kTextGrey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: sessions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _SessionCard(
                        session: sessions[i],
                        onViewDetails: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SessionReportScreen()),
                        ),
                      ),
                    ),
        ),
      ]),
    );
  }
}

// ── Session Card ─────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final _Session session;
  final VoidCallback onViewDetails;

  const _SessionCard({required this.session, required this.onViewDetails});

  Color get _scoreColor {
    if (session.score >= 80) return _kGreen;
    if (session.score >= 60) return _kOrange;
    return _kRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Top row — date + score
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                color: _kBlue, size: 16),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${session.date} · ${session.time}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _kTextDark)),
            Text(session.machine,
                style: const TextStyle(fontSize: 11, color: _kTextGrey)),
          ]),
          const Spacer(),

          // Health score mini badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _scoreColor, width: 2.5),
            ),
            child: Center(
              child: Text('${session.score}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor)),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        const Divider(height: 1, color: _kBorder),
        const SizedBox(height: 12),

        // Readings row
        Wrap(spacing: 10, runSpacing: 8, children: [
          _ReadingBadge(label: 'BP', value: session.bp, unit: 'mmHg'),
          _ReadingBadge(label: 'Sugar', value: session.sugar, unit: 'mg/dL'),
          _ReadingBadge(label: 'Pulse', value: session.pulse, unit: 'bpm'),
          _ReadingBadge(label: 'Temp', value: session.temp, unit: '°C'),
          _ReadingBadge(label: 'SpO₂', value: session.spo2, unit: '%'),
        ]),
        const SizedBox(height: 12),

        // View Details button
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: onViewDetails,
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('View Details',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _kBlue,
              side: const BorderSide(color: _kBlue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ReadingBadge extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _ReadingBadge(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$label: ',
            style: const TextStyle(fontSize: 11, color: _kTextGrey)),
        Text(value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: _kTextDark)),
        Text(' $unit', style: const TextStyle(fontSize: 10, color: _kTextGrey)),
      ]),
    );
  }
}

// ── Data Model ───────────────────────────────────────────────
enum _SessionStatus { normal, warning, danger }

class _Session {
  final String id, date, time, machine, bp, sugar, pulse, temp, spo2;
  final int score, daysAgo;
  final _SessionStatus status;

  const _Session({
    required this.id,
    required this.date,
    required this.time,
    required this.machine,
    required this.bp,
    required this.sugar,
    required this.pulse,
    required this.temp,
    required this.spo2,
    required this.score,
    required this.status,
    required this.daysAgo,
  });
}
