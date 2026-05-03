import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/mock_data.dart';
import '../models/models.dart';

class MachinesScreen extends StatelessWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            BlueHeader(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Machines',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Find nearby health kiosks',
                          style:
                              TextStyle(fontSize: 13, color: Colors.white70)),
                    ]),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 20),
                ),
              ]),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nearest machine
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: c.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: c.divider)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.location_on_outlined,
                                  color: c.textSecond, size: 16),
                              const SizedBox(width: 4),
                              Text('Nearest Machine',
                                  style: TextStyle(
                                      fontSize: 13, color: c.textSecond)),
                            ]),
                            const SizedBox(height: 10),
                            Row(children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text('Central Health Hub',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: c.textPrimary)),
                                    const SizedBox(height: 4),
                                    Text('123 Main St, Central Park',
                                        style: TextStyle(
                                            fontSize: 13, color: c.textSecond)),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      Text('0.3 km',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: c.primary)),
                                      const SizedBox(width: 10),
                                      Icon(Icons.wifi,
                                          color: c.available, size: 14),
                                      const SizedBox(width: 3),
                                      Text('Available',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: c.available,
                                              fontWeight: FontWeight.w500)),
                                    ]),
                                  ])),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.navigation_outlined,
                                    size: 16),
                                label: const Text('Navigate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: c.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                ),
                              ),
                            ]),
                          ]),
                    ),
                    const SizedBox(height: 14),

                    // Map placeholder
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: c.divider),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(children: [
                          CustomPaint(
                              size: const Size(double.infinity, 200),
                              painter: _Grid(c.divider)),
                          Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Icon(Icons.map_outlined,
                                    size: 40, color: c.textSecond),
                                const SizedBox(height: 8),
                                Text('Google Maps',
                                    style: TextStyle(
                                        fontSize: 13, color: c.textSecond)),
                              ])),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('All Machines',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: c.textPrimary)),
                    const SizedBox(height: 12),

                    ...MockDataService.machines.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                                color: c.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: c.divider)),
                            child: Row(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: c.scaffold,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                    m.isAvailable ? Icons.wifi : Icons.wifi_off,
                                    color:
                                        m.isAvailable ? c.available : c.offline,
                                    size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(m.name,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: c.textPrimary)),
                                    Text('${m.id} · ${m.distanceKm} km',
                                        style: TextStyle(
                                            fontSize: 12, color: c.textSecond)),
                                  ])),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color:
                                      m.isAvailable ? c.normalBg : c.dangerBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                    m.isAvailable ? 'Available' : 'Offline',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: m.isAvailable
                                            ? c.normalText
                                            : c.dangerText)),
                              ),
                            ]),
                          ),
                        )),
                    const SizedBox(height: 80),
                  ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Grid extends CustomPainter {
  final Color color;
  _Grid(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 0.6;
    for (double x = 0; x < size.width; x += 36)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 36)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }

  @override
  bool shouldRepaint(_Grid o) => false;
}
