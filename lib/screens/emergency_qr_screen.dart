import 'package:flutter/material.dart';

const _kBlue = Color(0xFF2196F3);
const _kBg = Color(0xFFF5F7FA);
const _kCard = Colors.white;
const _kBorder = Color(0xFFE0E0E0);
const _kTextDark = Color(0xFF1A1A2E);
const _kTextGrey = Color(0xFF757575);
const _kRed = Color(0xFFEF5350);

class EmergencyQrScreen extends StatelessWidget {
  const EmergencyQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kRed,
        foregroundColor: Colors.white,
        title: const Text('Emergency QR Code'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _kRed.withOpacity(0.1),
              border: Border.all(color: _kRed.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Icon(Icons.emergency_outlined, color: _kRed),
              const SizedBox(width: 10),
              const Expanded(child: Text('Show this QR code...')),
            ]),
          ),
          const SizedBox(height: 20),
          _Card(
            child: Column(children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: _kBorder),
                ),
                child: const Center(child: Text("QR")),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: child,
    );
  }
}
