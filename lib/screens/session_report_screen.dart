import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../theme/app_theme.dart';
import '../services/share_helper.dart';

const _kBlue = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
const _kGreen = Color(0xFF4CAF50);
const _kOrange = Color(0xFFFFA726);
const _kRed = Color(0xFFEF5350);

// ══════════════════════════════════════════════════════════════
//  SessionReportScreen
// ══════════════════════════════════════════════════════════════
class SessionReportScreen extends StatelessWidget {
  const SessionReportScreen({super.key});

  // ── Download PDF ─────────────────────────────────────────
  Future<void> _downloadPdf(BuildContext context) async {
    try {
      _showLoading(context, 'Generating PDF...');

      final bytes = await ShareHelper.buildPdfBytes(_kSessionData);
      if (!context.mounted) return;
      Navigator.pop(context);
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'SmartHealth_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showError(context, 'Failed to generate PDF');
      }
    }
  }

  // ── Share Report ─────────────────────────────────────────
  Future<void> _shareReport(BuildContext context) async {
    await ShareHelper.shareReport(context, _kSessionData);
  }

  static const _kSessionData = ShareReportData(
    title: 'Full Health Report',
    date: 'Today, March 21 - 10:32 AM',
    machine: 'Machine #MH-042 - Central Health Hub',
    score: 82,
    status: 'Normal',
    bp: '120/80',
    sugar: '98',
    temp: '36.5',
    pulse: '72',
    spo2: '98',
  );

  void _showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(children: [
          const CircularProgressIndicator(color: _kBlue, strokeWidth: 3),
          const SizedBox(width: 16),
          Text(message,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color)),
        ]),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _kRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      body: CustomScrollView(
        slivers: [
          // ── Blue header ──────────────────────────────────
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Machine #MH-042',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary)),
                          SizedBox(height: 2),
                          Text('Central Health Hub · Today 10:28 AM',
                              style:
                                  TextStyle(fontSize: 12, color: c.textSecond)),
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
                _SectionTitle('Measurements'),
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
                _SectionTitle('Recommendations'),
                const SizedBox(height: 10),
                _Card(
                  child: Column(children: [
                    _RecommendationItem(
                      icon: Icons.local_drink_outlined,
                      iconColor: const Color(0xFF42A5F5),
                      text:
                          'Stay hydrated. Drink at least 8 glasses of water daily.',
                    ),
                    Divider(height: 20, color: c.divider),
                    _RecommendationItem(
                      icon: Icons.directions_walk_outlined,
                      iconColor: _kGreen,
                      text:
                          'Light physical activity such as a 30-minute walk is beneficial.',
                    ),
                    Divider(height: 20, color: c.divider),
                    _RecommendationItem(
                      icon: Icons.bedtime_outlined,
                      iconColor: const Color(0xFF7B61FF),
                      text:
                          'Maintain a regular sleep schedule (7–8 hours per night).',
                    ),
                    Divider(height: 20, color: c.divider),
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
                      onTap: () => _downloadPdf(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryBtn(
                      label: 'Share Report',
                      icon: Icons.share_outlined,
                      onTap: () => _shareReport(context),
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
    case _Status.normal:
      return _kGreen;
    case _Status.warning:
      return _kOrange;
    case _Status.danger:
      return _kRed;
  }
}

String _statusLabel(_Status s) {
  switch (s) {
    case _Status.normal:
      return 'Normal';
    case _Status.warning:
      return 'Warning';
    case _Status.danger:
      return 'High';
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
    final c = context.colors;
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary)),
            Text(note, style: TextStyle(fontSize: 11, color: c.textSecond)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary)),
                const SizedBox(width: 3),
                Text(unit, style: TextStyle(fontSize: 11, color: c.textSecond)),
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
    final c = context.colors;
    return _Card(
      child: Row(children: [
        Icon(icon, color: _kBlue, size: 22),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: c.textSecond)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary)),
                const SizedBox(width: 3),
                Text(unit, style: TextStyle(fontSize: 11, color: c.textSecond)),
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
    final c = context.colors;
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
            style: TextStyle(fontSize: 13, color: c.textPrimary, height: 1.4)),
      ),
    ]);
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(text,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: c.textPrimary));
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryBtn(
      {required this.label, required this.icon, required this.onTap});
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineBtn(
      {required this.label, required this.icon, required this.onTap});
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
