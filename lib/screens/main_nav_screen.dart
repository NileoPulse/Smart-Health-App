import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';
import 'vitals_screen.dart';
import 'alerts_screen.dart';
import 'machines_screen.dart';
import 'more_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _index;
  bool _showAssistant = false;

  @override
  void initState() {
    super.initState();
    // Restore last visited tab
    _index = context.read<AppState>().lastNavIndex;
  }

  void _goTo(int i) {
    setState(() {
      _index = i;
      _showAssistant = false;
    });
    // Save last tab
    context.read<AppState>().setNavIndex(i);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final screens = [
      HomeScreen(
        onGoToVitals: () => _goTo(1),
        onGoToMachines: () => _goTo(3),
        onGoToReports: () => _goTo(2),
      ),
      const VitalsScreen(),
      const AlertsScreen(),
      const MachinesScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      appBar: SmartHealthAppBar(
        onProfileTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: IndexedStack(index: _index, children: screens),
          ),

          // Barrier — يمنع التفاعل مع أي حاجة وراء الـ chatbot
          if (_showAssistant)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: ModalBarrier(
                  dismissible: true,
                  color: Colors.black.withOpacity(0.25),
                  onDismiss: () => setState(() => _showAssistant = false),
                ),
              ),
            ),

          // Chat overlay
          if (_showAssistant)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: HealthAssistantOverlay(
                onClose: () => setState(() => _showAssistant = false),
              ),
            ),

          // Chat FAB
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => setState(() => _showAssistant = !_showAssistant),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: c.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  _showAssistant ? Icons.close : Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: _goTo,
      ),
    );
  }
}
