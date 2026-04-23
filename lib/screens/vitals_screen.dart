import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'session_report_screen.dart';

// ── Status colors only (not theme-dependent) ──────────────────
const _kBlue     = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
const _kGreen    = Color(0xFF4CAF50);
const _kOrange   = Color(0xFFFFA726);
const _kRed      = Color(0xFFEF5350);

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});
  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  int _trendTab = 0;

  final Map<int, List<double>> _trendData = {
    0: [36.5, 36.8, 37.1, 36.9, 36.7, 36.8, 36.5],
    1: [70.0, 74.0, 72.0, 75.0, 71.0, 73.0, 72.0],
    2: [97.0, 98.0, 98.0, 97.0, 99.0, 98.0, 98.0],
    3: [118.0, 122.0, 125.0, 120.0, 119.0, 124.0, 121.0],
    4: [95.0, 98.0, 102.0, 97.0, 99.0, 105.0, 100.0],
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            // ── Blue Header ──────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
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
                      children: const [
                        Text('Vitals & Reports',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Last synced: Today, 10:32 AM',
                            style: TextStyle(fontSize: 13, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _HealthScoreCard(score: 82),
                  const SizedBox(height: 14),
                  const _MachineUpdateCard(),
                  const SizedBox(height: 14),
                  _SectionLabel('Latest Readings'),
                  const SizedBox(height: 10),
                  _BloodPressureCard(
                    systolic: 120,
                    diastolic: 80,
                    chartData: _trendData[3]!,
                  ),
                  const SizedBox(height: 10),
                  _BloodSugarCard(
                    value: 98,
                    chartData: _trendData[4]!,
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: _SmallVitalCard(
                        icon: Icons.thermostat_outlined,
                        iconColor: const Color(0xFF1976D2),
                        title: 'Temperature',
                        value: '36.5',
                        unit: '°C',
                        status: _VitalStatus.normal,
                        chartData: _trendData[0]!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SmallVitalCard(
                        icon: Icons.favorite_border_rounded,
                        iconColor: _kRed,
                        title: 'Pulse',
                        value: '72',
                        unit: 'bpm',
                        status: _VitalStatus.normal,
                        chartData: _trendData[1]!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SmallVitalCard(
                        icon: Icons.water_drop_outlined,
                        iconColor: const Color(0xFF1976D2),
                        title: 'SpO₂',
                        value: '98',
                        unit: '%',
                        status: _VitalStatus.normal,
                        chartData: _trendData[2]!,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _SectionLabel('Trends'),
                  const SizedBox(height: 10),
                  _TrendsCard(
                    trendTab: _trendTab,
                    trendData: _trendData,
                    onTabChange: (i) => setState(() => _trendTab = i),
                  ),
                  const SizedBox(height: 14),

                  // ── Generate Report + Description (connected) ─
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Column(children: [
                      // Blue button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SessionReportScreen()),
                          ),
                          icon: const Icon(Icons.show_chart_rounded, size: 18),
                          label: const Text('Generate Report',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                        ),
                      ),
                      // Light blue description — no gap
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        color: const Color(0xFFBBDEFB),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline_rounded,
                                color: Color(0xFF1565C0), size: 14),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Reports include: vital sign history, trend analysis, health score breakdown, and AI-generated recommendations. Available in PDF and CSV formats.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF1565C0),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: _kBlue,
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  HEALTH SCORE CARD
// ══════════════════════════════════════════════════════════════
class _HealthScoreCard extends StatelessWidget {
  final int score;
  const _HealthScoreCard({required this.score});

  Color get _arcColor {
    if (score >= 80) return _kGreen;
    if (score >= 60) return _kOrange;
    return _kRed;
  }

  String get _label {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Needs Attention';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      child: Column(children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 12,
                backgroundColor: c.divider,
                valueColor: AlwaysStoppedAnimation<Color>(c.divider),
                strokeCap: StrokeCap.round,
              ),
            ),
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 12,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(_arcColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('$score',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary)),
              Text('/ 100',
                  style: TextStyle(fontSize: 13, color: c.textSecond)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Text('Health Score',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: c.textPrimary)),
        const SizedBox(height: 8),
        _StatusBadge(label: _label, status: _VitalStatus.normal),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LATEST MACHINE UPDATE CARD
// ══════════════════════════════════════════════════════════════
class _MachineUpdateCard extends StatelessWidget {
  const _MachineUpdateCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _kBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.monitor_outlined, color: _kBlue, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Latest Machine Update',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 2),
            Text('Machine #MH-042 · Central Health Hub',
                style: TextStyle(fontSize: 12, color: c.textSecond)),
            const SizedBox(height: 2),
            Text('Today, 10:32 AM',
                style: TextStyle(fontSize: 11, color: c.textSecond)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('Synced',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: _kGreen)),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  BLOOD PRESSURE CARD
// ══════════════════════════════════════════════════════════════
class _BloodPressureCard extends StatelessWidget {
  final int systolic;
  final int diastolic;
  final List<double> chartData;

  const _BloodPressureCard({
    required this.systolic,
    required this.diastolic,
    required this.chartData,
  });

  _VitalStatus get _status {
    if (systolic < 120 && diastolic < 80) return _VitalStatus.normal;
    if (systolic < 130) return _VitalStatus.warning;
    return _VitalStatus.danger;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const purple = Color(0xFF6366F1);
    return _Card(
      child: Column(children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.water_drop_outlined, color: purple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Blood Pressure',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
          ),
          _StatusBadge(label: _statusLabel(_status), status: _status),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _BpValue(label: 'SYS', value: systolic, unit: 'mmHg'),
          Container(width: 1, height: 40, color: c.divider),
          _BpValue(label: 'DIA', value: diastolic, unit: 'mmHg'),
          Container(width: 1, height: 40, color: c.divider),
          Column(children: [
            Text('$systolic/$diastolic',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            Text('Combined',
                style: TextStyle(fontSize: 10, color: c.textSecond)),
          ]),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: CustomPaint(
            size: const Size(double.infinity, 40),
            painter: _MiniLinePainter(chartData, purple, c.card),
          ),
        ),
      ]),
    );
  }
}

class _BpValue extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  const _BpValue({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: c.textSecond)),
      const SizedBox(height: 2),
      Text('$value',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: c.textPrimary)),
      Text(unit, style: TextStyle(fontSize: 10, color: c.textSecond)),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════
//  BLOOD SUGAR CARD
// ══════════════════════════════════════════════════════════════
class _BloodSugarCard extends StatelessWidget {
  final int value;
  final List<double> chartData;

  const _BloodSugarCard({required this.value, required this.chartData});

  _VitalStatus get _status {
    if (value < 100) return _VitalStatus.normal;
    if (value < 126) return _VitalStatus.warning;
    return _VitalStatus.danger;
  }

  String get _sugarLabel {
    if (value < 100) return 'Normal (Fasting)';
    if (value < 126) return 'Pre-diabetic Range';
    return 'Diabetic Range';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _kOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bloodtype_outlined, color: _kOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Blood Sugar',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
          ),
          _StatusBadge(label: _statusLabel(_status), status: _status),
        ]),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$value',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary)),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('mg/dL',
                style: TextStyle(fontSize: 14, color: c.textSecond)),
          ),
          const Spacer(),
          Text(_sugarLabel,
              style: TextStyle(
                  fontSize: 12,
                  color: _statusColor(_status),
                  fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: CustomPaint(
            size: const Size(double.infinity, 36),
            painter: _MiniLinePainter(chartData, _kOrange, c.card),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SMALL VITAL CARD
// ══════════════════════════════════════════════════════════════
class _SmallVitalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final _VitalStatus status;
  final List<double> chartData;

  const _SmallVitalCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(height: 6),
        Text(title,
            style: TextStyle(fontSize: 10, color: c.textSecond),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary)),
              const SizedBox(width: 2),
              Text(unit,
                  style: TextStyle(fontSize: 9, color: c.textSecond)),
            ]),
        const SizedBox(height: 6),
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: _statusColor(status).withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: _statusColor(status),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(_statusLabel(status),
            style: TextStyle(
                fontSize: 9,
                color: _statusColor(status),
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  TRENDS CARD
// ══════════════════════════════════════════════════════════════
class _TrendsCard extends StatelessWidget {
  final int trendTab;
  final Map<int, List<double>> trendData;
  final ValueChanged<int> onTabChange;

  const _TrendsCard({
    required this.trendTab,
    required this.trendData,
    required this.onTabChange,
  });

  static const _tabs = ['Temp', 'Pulse', 'SpO₂', 'BP', 'Sugar'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Trends',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: c.textPrimary)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final sel = trendTab == i;
              return GestureDetector(
                onTap: () => onTabChange(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel ? _kBlue : c.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? _kBlue : c.divider),
                  ),
                  child: Text(_tabs[i],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : c.textSecond)),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: _FullLineChart(data: trendData[trendTab]!),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════════
enum _VitalStatus { normal, warning, danger }

Color _statusColor(_VitalStatus s) {
  switch (s) {
    case _VitalStatus.normal:  return _kGreen;
    case _VitalStatus.warning: return _kOrange;
    case _VitalStatus.danger:  return _kRed;
  }
}

String _statusLabel(_VitalStatus s) {
  switch (s) {
    case _VitalStatus.normal:  return 'Normal';
    case _VitalStatus.warning: return 'Warning';
    case _VitalStatus.danger:  return 'High';
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final _VitalStatus status;
  const _StatusBadge({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: c.textPrimary));
  }
}

// ── Shared Card Widget ────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
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
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}

// ── Mini line painter ─────────────────────────────────────────
class _MiniLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final Color dotCenter; // adapts to card background for dark mode

  _MiniLinePainter(this.data, this.color, this.dotCenter);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final min = data.reduce(math.min);
    final max = data.reduce(math.max);
    final range = (max - min) == 0 ? 1.0 : max - min;

    final pts = List.generate(
        data.length,
        (i) => Offset(
              size.width * i / (data.length - 1),
              size.height - (data[i] - min) / range * size.height * 0.8 - size.height * 0.1,
            ));

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }

    final fill = Path.from(path)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(path, paint);

    for (final p in pts) {
      canvas.drawCircle(p, 3, Paint()..color = color..style = PaintingStyle.fill);
      canvas.drawCircle(p, 2, Paint()..color = dotCenter..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_MiniLinePainter old) => true;
}

// ── Full Bar Chart ────────────────────────────────────────────
class _FullLineChart extends StatelessWidget {
  final List<double> data;
  const _FullLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final min = data.reduce(math.min);
    final max = data.reduce(math.max);
    final mid = (min + max) / 2;

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(children: [
      // Y-axis labels
      SizedBox(
        width: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(max.toStringAsFixed(0),
                style: TextStyle(fontSize: 10, color: c.textSecond)),
            Text(mid.toStringAsFixed(0),
                style: TextStyle(fontSize: 10, color: c.textSecond)),
            Text(min.toStringAsFixed(0),
                style: TextStyle(fontSize: 10, color: c.textSecond)),
          ],
        ),
      ),
      // Bars + X-axis
      Expanded(
        child: Column(children: [
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _BarChartPainter(data, c.divider, c.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((d) => Text(d,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF757575))))
                .toList(),
          ),
        ]),
      ),
    ]);
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final Color gridColor;
  final Color barColor;

  _BarChartPainter(this.data, this.gridColor, this.barColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Grid lines
    final gridPaint = Paint()..color = gridColor..strokeWidth = 0.8;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final min = data.reduce(math.min);
    final max = data.reduce(math.max);
    final range = (max - min) == 0 ? 1.0 : max - min;

    final barWidth = size.width / data.length * 0.5;
    final gap = size.width / data.length;

    for (int i = 0; i < data.length; i++) {
      final barHeight =
          (data[i] - min) / range * size.height * 0.8 + size.height * 0.08;
      final x = gap * i + gap / 2;
      final top = size.height - barHeight;

      // Shadow bar (slightly wider, lighter)
      final shadowRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2 - 1, top + 4, barWidth + 2, barHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        shadowRect,
        Paint()..color = barColor.withValues(alpha: 0.15),
      );

      // Main bar
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, top, barWidth, barHeight),
        const Radius.circular(6),
      );

      // Gradient fill
      canvas.drawRRect(
        barRect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              barColor,
              barColor.withValues(alpha: 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
              Rect.fromLTWH(x - barWidth / 2, top, barWidth, barHeight)),
      );

      // Value label on top of bar
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].toStringAsFixed(
              data[i] % 1 == 0 ? 0 : 1),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: barColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, top - 14),
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => true;
}
