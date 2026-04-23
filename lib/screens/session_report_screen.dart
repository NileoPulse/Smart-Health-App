import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

const _kBlue     = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
const _kBg       = Color(0xFFF5F7FA);
const _kCard     = Colors.white;
const _kBorder   = Color(0xFFE0E0E0);
const _kTextDark = Color(0xFF1A1A2E);
const _kTextGrey = Color(0xFF757575);
const _kGreen    = Color(0xFF4CAF50);
const _kOrange   = Color(0xFFFFA726);
const _kRed      = Color(0xFFEF5350);

class SessionReportScreen extends StatelessWidget {
  const SessionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: CustomScrollView(
        slivers: [
          // ── Blue header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kBlueDark, _kBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
                          const Text('Session Report',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ]),
                        const SizedBox(height: 4),
                        const Padding(
                          padding: EdgeInsets.only(left: 34),
                          child: Text('Today, March 21 · 10:32 AM',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: _kBlue,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Machine info ─────────────────────────────
                _Card(
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _kBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.monitor_outlined,
                          color: _kBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Machine #MH-042',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _kTextDark)),
                          SizedBox(height: 2),
                          Text('Central Health Hub · Today 10:28 AM',
                              style: TextStyle(
                                  fontSize: 12, color: _kTextGrey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _kGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Complete',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _kGreen)),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── Readings ─────────────────────────────────
                const _SectionTitle('Measurements'),
                const SizedBox(height: 10),
                _ReportReadingCard(
                  icon: Icons.water_drop_outlined,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Blood Pressure',
                  value: '120 / 80',
                  unit: 'mmHg',
                  status: _Status.normal,
                  note: 'Systolic / Diastolic',
                ),
                const SizedBox(height: 8),
                _ReportReadingCard(
                  icon: Icons.bloodtype_outlined,
                  iconColor: _kOrange,
                  title: 'Blood Sugar',
                  value: '98',
                  unit: 'mg/dL',
                  status: _Status.normal,
                  note: 'Fasting blood glucose',
                ),
                const SizedBox(height: 8),
                _ReportReadingCard(
                  icon: Icons.thermostat_outlined,
                  iconColor: const Color(0xFF1976D2),
                  title: 'Temperature',
                  value: '36.5',
                  unit: '°C',
                  status: _Status.normal,
                  note: 'Body temperature',
                ),
                const SizedBox(height: 8),
                _ReportReadingCard(
                  icon: Icons.favorite_border_rounded,
                  iconColor: _kRed,
                  title: 'Pulse Rate',
                  value: '72',
                  unit: 'bpm',
                  status: _Status.normal,
                  note: 'Heart rate',
                ),
                const SizedBox(height: 8),
                _ReportReadingCard(
                  icon: Icons.water_outlined,
                  iconColor: const Color(0xFF42A5F5),
                  title: 'SpO₂',
                  value: '98',
                  unit: '%',
                  status: _Status.normal,
                  note: 'Oxygen saturation',
                ),
                const SizedBox(height: 8),

                // Height / Weight
                Row(children: [
                  Expanded(
                    child: _SimpleMetricCard(
                        icon: Icons.height,
                        label: 'Height',
                        value: '175',
                        unit: 'cm'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SimpleMetricCard(
                        icon: Icons.monitor_weight_outlined,
                        label: 'Weight',
                        value: '72',
                        unit: 'kg'),
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Recommendations ──────────────────────────
                const _SectionTitle('Recommendations'),
                const SizedBox(height: 10),
                _Card(
                  child: Column(children: [
                    _RecommendationItem(
                      icon: Icons.local_drink_outlined,
                      iconColor: const Color(0xFF42A5F5),
                      text:
                          'Stay hydrated. Drink at least 8 glasses of water daily.',
                    ),
                    const Divider(height: 20, color: _kBorder),
                    _RecommendationItem(
                      icon: Icons.directions_walk_outlined,
                      iconColor: _kGreen,
                      text:
                          'Light physical activity such as a 30-minute walk is beneficial.',
                    ),
                    const Divider(height: 20, color: _kBorder),
                    _RecommendationItem(
                      icon: Icons.bedtime_outlined,
                      iconColor: const Color(0xFF7B61FF),
                      text:
                          'Maintain a regular sleep schedule (7–8 hours per night).',
                    ),
                    const Divider(height: 20, color: _kBorder),
                    _RecommendationItem(
                      icon: Icons.monitor_heart_outlined,
                      iconColor: _kRed,
                      text:
                          'Schedule your next health check in 30 days or visit a nearby machine.',
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // ── Action Buttons ───────────────────────────
                Row(children: [
                  Expanded(
                    child: _OutlineBtn(
                      label: 'Download PDF',
                      icon: Icons.download_outlined,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryBtn(
                      label: 'Share Report',
                      icon: Icons.share_outlined,
                      onTap: () {
                        Share.share(
                          '🏥 SmartHealth Report\n'
                          '📅 Today, March 21 · 10:32 AM\n'
                          '📍 Machine #MH-042 — Central Health Hub\n\n'
                          '📊 Health Score: 82 / 100\n\n'
                          '❤️  Blood Pressure : 120/80 mmHg — Normal\n'
                          '🩸  Blood Sugar    : 98 mg/dL  — Normal\n'
                          '🌡️  Temperature    : 36.5 °C   — Normal\n'
                          '💓  Pulse Rate     : 72 bpm    — Normal\n'
                          '💧  SpO₂           : 98%       — Normal\n\n'
                          'Generated by SmartHealth App 💙',
                          subject: 'My SmartHealth Report',
                        );
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────

enum _Status { normal, warning, danger }

Color _statusColor(_Status s) {
  switch (s) {
    case _Status.normal:  return _kGreen;
    case _Status.warning: return _kOrange;
    case _Status.danger:  return _kRed;
  }
}

String _statusLabel(_Status s) {
  switch (s) {
    case _Status.normal:  return 'Normal';
    case _Status.warning: return 'Warning';
    case _Status.danger:  return 'High';
  }
}

class _ReportReadingCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final _Status status;
  final String note;

  const _ReportReadingCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kTextDark)),
            Text(note,
                style: const TextStyle(fontSize: 11, color: _kTextGrey)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _kTextDark)),
                const SizedBox(width: 3),
                Text(unit,
                    style: const TextStyle(
                        fontSize: 11, color: _kTextGrey)),
              ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_statusLabel(status),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status))),
          ),
        ]),
      ]),
    );
  }
}

class _SimpleMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _SimpleMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(children: [
        Icon(icon, color: _kBlue, size: 22),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: _kTextGrey)),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _kTextDark)),
                const SizedBox(width: 3),
                Text(unit,
                    style: const TextStyle(
                        fontSize: 11, color: _kTextGrey)),
              ]),
        ]),
      ]),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _RecommendationItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(text,
            style: const TextStyle(
                fontSize: 13, color: _kTextDark, height: 1.4)),
      ),
    ]);
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: _kTextDark));
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineBtn({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: _kBlue,
          side: const BorderSide(color: _kBlue),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
