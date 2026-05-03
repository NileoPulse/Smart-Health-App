import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onGoToVitals;
  final VoidCallback? onGoToMachines;
  final VoidCallback? onGoToReports;

  const HomeScreen({
    super.key,
    this.onGoToVitals,
    this.onGoToMachines,
    this.onGoToReports,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              /// 🔵 Header
              BlueHeader(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Welcome back,',
                          style:
                              TextStyle(fontSize: 14, color: Colors.white70)),
                      SizedBox(height: 4),
                      Text('Alex Johnson',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),

              /// 🟦 Grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _HomeCard(
                      icon: Icons.favorite_border,
                      iconColor: c.primary,
                      title: 'Vitals',
                      subtitle: 'Check your readings',
                      onTap: () => widget.onGoToVitals?.call(),
                    ),
                    _HomeCard(
                      icon: Icons.show_chart,
                      iconColor: c.normalText,
                      title: 'Reports',
                      subtitle: 'View health reports',
                      onTap: () => widget.onGoToReports?.call(),
                    ),
                    _HomeCard(
                      icon: Icons.devices,
                      iconColor: c.primary,
                      title: 'Machines',
                      subtitle: 'Find nearby devices',
                      onTap: () => widget.onGoToMachines?.call(),
                    ),
                    _HomeCard(
                      icon: Icons.favorite,
                      iconColor: c.warningText,
                      title: 'Health Score',
                      subtitle: 'Your wellness score',
                      onTap: () => widget.onGoToVitals?.call(),
                    ),
                  ],
                ),
              ),

              /// 📊 Dashboard
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.divider),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: c.infoBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(Icons.monitor_heart,
                              size: 56, color: c.primary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Your Health Dashboard',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c.textPrimary)),
                      const SizedBox(height: 6),
                      Text(
                        'Track your vitals and get AI-powered insights in real time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, color: c.textSecond, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              /// 📈 Recent Stats
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Stats',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: c.textPrimary)),
                      const SizedBox(height: 14),
                      _recentRow(c, 'Blood Pressure', '120/80 mmHg', '2h ago'),
                      Divider(color: c.divider),
                      _recentRow(c, 'Heart Rate', '72 bpm', '2h ago'),
                      Divider(color: c.divider),
                      _recentRow(c, 'SpO₂', '98%', '2h ago'),
                      Divider(color: c.divider),
                      _recentRow(c, 'Blood Sugar', '110 mg/dL', '2h ago'),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _recentRow(AppColors c, String title, String value, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: c.textPrimary)),
              Text(time, style: TextStyle(fontSize: 12, color: c.textSecond)),
            ]),
          ),
          Text(value,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
          const SizedBox(width: 10),
          const StatusBadge(label: 'Normal', type: StatusType.normal),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const Spacer(),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: c.textSecond)),
          ],
        ),
      ),
    );
  }
}
