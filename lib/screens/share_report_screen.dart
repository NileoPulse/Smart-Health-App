import 'package:flutter/material.dart';

const _kBlue = Color(0xFF2196F3);
const _kBg = Color(0xFFF5F7FA);
const _kBorder = Color(0xFFE0E0E0);
const _kTextDark = Color(0xFF1A1A2E);

class ShareReportScreen extends StatelessWidget {
  const ShareReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        title: const Text("Share Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _Option(Icons.picture_as_pdf, "Save as PDF"),
          _Option(Icons.chat, "WhatsApp"),
          _Option(Icons.email, "Email"),
        ]),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Option(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icon, color: _kBlue),
        const SizedBox(width: 10),
        Text(text),
      ]),
    );
  }
}
