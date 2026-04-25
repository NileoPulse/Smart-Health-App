import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import '../theme/app_theme.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

// ── ألوان ثابتة للـ UI (الثيم-independent) ───────────────────
const _kBlue = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
// ✅ حُذف _kBg و _kCard — استُبدلا بـ context.colors.scaffold و context.colors.card
const _kBorder = Color(0xFFE0E0E0);
const _kTextDark = Color(0xFF1A1A2E);
const _kTextGrey = Color(0xFF757575);
const _kGreen = Color(0xFF4CAF50);
const _kOrange = Color(0xFFFFA726);
const _kRed = Color(0xFFEF5350);

// ══════════════════════════════════════════════════════════════
//  PDF Generator — كل منطق بناء الـ PDF هنا في مكان واحد
//  ⚠️ لا تعديل هنا — الـ PDF يستخدم ألوان ثابتة بطبيعته
// ══════════════════════════════════════════════════════════════
class _PdfGenerator {
  static Future<Uint8List> build() async {
    final doc = pw.Document();

    // ── Color helpers ──────────────────────────────────
    const blue = PdfColor.fromInt(0xFF2196F3);
    const blueDark = PdfColor.fromInt(0xFF1565C0);
    const green = PdfColor.fromInt(0xFF4CAF50);
    const textDark = PdfColor.fromInt(0xFF1A1A2E);
    const textGrey = PdfColor.fromInt(0xFF757575);
    const bgLight = PdfColor.fromInt(0xFFF5F7FA);
    const white = PdfColors.white;
    const border = PdfColor.fromInt(0xFFE0E0E0);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) => [
          // ── Header ──────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [blueDark, blue],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('SmartHealth Report',
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: white)),
                    pw.SizedBox(height: 4),
                    pw.Text('Today, March 21 · 10:32 AM',
                        style: pw.TextStyle(fontSize: 12, color: white)),
                    pw.Text('Machine #MH-042 - Central Health Hub',
                        style: pw.TextStyle(fontSize: 11, color: white)),
                  ],
                ),
                pw.Container(
                  width: 64,
                  height: 64,
                  decoration: pw.BoxDecoration(
                    color: white,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('82',
                            style: pw.TextStyle(
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                color: blue)),
                        pw.Text('/100',
                            style: pw.TextStyle(fontSize: 10, color: textGrey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ── Section: Measurements ─────────────────
          _pdfSectionTitle('Measurements', textDark),
          pw.SizedBox(height: 10),
          _pdfReadingRow('Blood Pressure', '120 / 80', 'mmHg', 'Normal', green,
              border, textDark, textGrey),
          _pdfReadingRow('Blood Sugar', '98', 'mg/dL', 'Normal', green, border,
              textDark, textGrey),
          _pdfReadingRow('Temperature', '36.5', '°C', 'Normal', green, border,
              textDark, textGrey),
          _pdfReadingRow('Pulse Rate', '72', 'bpm', 'Normal', green, border,
              textDark, textGrey),
          _pdfReadingRow(
              'SpO2', '98', '%', 'Normal', green, border, textDark, textGrey),
          pw.SizedBox(height: 8),

          // Height / Weight row
          pw.Row(children: [
            pw.Expanded(
                child: _pdfMetricBox('Height', '175 cm', blue, bgLight, border,
                    textDark, textGrey)),
            pw.SizedBox(width: 12),
            pw.Expanded(
                child: _pdfMetricBox('Weight', '72 kg', blue, bgLight, border,
                    textDark, textGrey)),
          ]),
          pw.SizedBox(height: 20),

          // ── Section: Recommendations ──────────────
          _pdfSectionTitle('Recommendations', textDark),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: bgLight,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: border),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _pdfRecommendation(
                    '• Stay hydrated. Drink at least 8 glasses of water daily.',
                    textDark),
                pw.SizedBox(height: 8),
                _pdfRecommendation(
                    '• Light physical activity such as a 30-minute walk is beneficial.',
                    textDark),
                pw.SizedBox(height: 8),
                _pdfRecommendation(
                    '• Maintain a regular sleep schedule (7–8 hours per night).',
                    textDark),
                pw.SizedBox(height: 8),
                _pdfRecommendation(
                    '• Schedule your next health check in 30 days or visit a nearby machine.',
                    textDark),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // ── Footer ────────────────────────────────
          pw.Divider(color: border),
          pw.SizedBox(height: 8),
          pw.Text(
            'Generated by SmartHealth App · ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: pw.TextStyle(fontSize: 10, color: textGrey),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );

    return Uint8List.fromList(await doc.save());
  }

  // ── PDF helper widgets ───────────────────────────────────

  static pw.Widget _pdfSectionTitle(String text, PdfColor color) {
    return pw.Text(text,
        style: pw.TextStyle(
            fontSize: 14, fontWeight: pw.FontWeight.bold, color: color));
  }

  static pw.Widget _pdfReadingRow(
    String label,
    String value,
    String unit,
    String status,
    PdfColor statusColor,
    PdfColor border,
    PdfColor textDark,
    PdfColor textGrey,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: border),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: textDark)),
          pw.Row(children: [
            pw.Text('$value $unit',
                style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    color: textDark)),
            pw.SizedBox(width: 10),
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: pw.BoxDecoration(
                color: PdfColor(
                    statusColor.red, statusColor.green, statusColor.blue, 0.15),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(status,
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: statusColor)),
            ),
          ]),
        ],
      ),
    );
  }

  static pw.Widget _pdfMetricBox(
    String label,
    String value,
    PdfColor iconColor,
    PdfColor bg,
    PdfColor border,
    PdfColor textDark,
    PdfColor textGrey,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: border),
      ),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 11, color: textGrey)),
        pw.SizedBox(height: 4),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold, color: textDark)),
      ]),
    );
  }

  static pw.Widget _pdfRecommendation(String text, PdfColor color) {
    return pw.Text(text,
        style: pw.TextStyle(fontSize: 12, color: color, lineSpacing: 2));
  }
}

// ══════════════════════════════════════════════════════════════
//  SessionReportScreen
// ══════════════════════════════════════════════════════════════
class SessionReportScreen extends StatelessWidget {
  const SessionReportScreen({super.key});

  // ── Download PDF ─────────────────────────────────────────
  Future<void> _downloadPdf(BuildContext context) async {
    try {
      // بنوري loading dialog
      _showLoading(context, 'Generating PDF...');

      final bytes = await _PdfGenerator.build();

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
    const shareText = 'SmartHealth Report\n'
        'Today, March 21 - 10:32 AM\n'
        'Machine #MH-042 - Central Health Hub\n\n'
        'Health Score: 82 / 100\n\n'
        'Blood Pressure : 120/80 mmHg - Normal\n'
        'Blood Sugar    : 98 mg/dL  - Normal\n'
        'Temperature    : 36.5 C   - Normal\n'
        'Pulse Rate     : 72 bpm    - Normal\n'
        'SpO2           : 98%       - Normal\n\n'
        'Generated by SmartHealth App';

    if (kIsWeb) {
      await Share.share(shareText, subject: 'My SmartHealth Report');
      return;
    }

    try {
      _showLoading(context, 'Preparing report...');

      final bytes = await _PdfGenerator.build();

      if (!context.mounted) return;
      Navigator.pop(context);

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/SmartHealth_Report.pdf');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'My SmartHealth Report',
        text: shareText,
      );
    } catch (e) {
      if (context.mounted) {
        // لو النافذة لسه مفتوحة، اقفلها
        try {
          Navigator.pop(context);
        } catch (_) {}
        _showError(context, 'Failed to share report');
      }
    }
  }

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
              style: const TextStyle(fontSize: 14, color: _kTextDark)),
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
    // ✅ Dark mode: نجيب scaffold و card من الثيم بدل _kBg و _kCard الثابتين
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold, // ✅ بدل _kBg
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
                              style:
                                  TextStyle(fontSize: 12, color: _kTextGrey)),
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
    // ✅ Dark mode: نستخدم c.textPrimary و c.textSecond بدل الثوابت
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
                    color: c.textPrimary)), // ✅ بدل _kTextDark
            Text(note,
                style: TextStyle(
                    fontSize: 11, color: c.textSecond)), // ✅ بدل _kTextGrey
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
                        color: c.textPrimary)), // ✅ بدل _kTextDark
                const SizedBox(width: 3),
                Text(unit,
                    style: TextStyle(
                        fontSize: 11, color: c.textSecond)), // ✅ بدل _kTextGrey
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
    // ✅ Dark mode: نستخدم c.textPrimary و c.textSecond
    final c = context.colors;
    return _Card(
      child: Row(children: [
        Icon(icon, color: _kBlue, size: 22),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: c.textSecond)), // ✅ بدل _kTextGrey
          Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary)), // ✅ بدل _kTextDark
                const SizedBox(width: 3),
                Text(unit,
                    style: TextStyle(
                        fontSize: 11, color: c.textSecond)), // ✅ بدل _kTextGrey
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
    // ✅ Dark mode: نستخدم c.textPrimary بدل _kTextDark
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
            style: TextStyle(
                fontSize: 13,
                color: c.textPrimary, // ✅ بدل _kTextDark
                height: 1.4)),
      ),
    ]);
  }
}

// ✅ _Card: استُبدلت _kCard بـ context.colors.card
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
        color: c.card, // ✅ بدل _kCard (Colors.white)
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

// ✅ _SectionTitle: استُبدلت _kTextDark بـ context.colors.textPrimary
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: c.textPrimary)); // ✅ بدل _kTextDark
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
