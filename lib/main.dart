import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_nav_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/health_profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // ── Init & load saved preferences ────────────────────
  final appState = AppState();
  await appState.init();
  await appState.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const SmartHealthApp(),
    ),
  );
}

class SmartHealthApp extends StatelessWidget {
  const SmartHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'SmartHealth',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.isDark ? ThemeMode.dark : ThemeMode.light,

      // ── Language / Locale ─────────────────────────────
      locale: Locale(appState.language),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],

      // ── RTL for Arabic ────────────────────────────────
      builder: (context, child) {
        return Directionality(
          textDirection:
              appState.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },

      // ── Skip login if already logged in ──────────────
      initialRoute: appState.isLoggedIn ? '/main' : '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/main': (_) => const MainNavScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/health-setup': (_) =>
            const HealthProfileSetupScreen(firstName: 'Mayar'),
      },
    );
  }
}
