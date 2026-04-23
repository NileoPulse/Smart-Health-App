import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../providers/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    // Save login state
    await context.read<AppState>().login();
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            // Blue header
            BlueHeader(
              height: 220,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 1.5),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 46,
                          height: 46,
                          child: CustomPaint(painter: _EcgLogoPainter()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('SmartHealth',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ]),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: c.textPrimary)),
                    const SizedBox(height: 6),
                    Text('Sign in to your account',
                        style: TextStyle(fontSize: 14, color: c.textSecond)),
                    const SizedBox(height: 28),

                    // Email field with validation
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: c.textPrimary),
                      decoration: _inputDeco(c, 'Email or Phone Number',
                          'Enter email or phone', Icons.email_outlined),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Email is required';
                        if (!v.contains('@') &&
                            !RegExp(r'^\d{10,}$').hasMatch(v)) {
                          return 'Enter a valid email or phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field with validation
                    _PasswordField(
                      controller: _passCtrl,
                      decoration: _inputDeco(
                          c, 'Password', 'Enter password', Icons.lock_outline),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password is required';
                        if (v.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/forgot-password'),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                color: c.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF2196F3)))
                        : BluePrimaryButton(label: 'Sign In', onTap: _signIn),

                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account? ",
                          style: TextStyle(color: c.textSecond, fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
                        child: Text('Sign Up',
                            style: TextStyle(
                                color: c.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(
      AppColors c, String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: c.textSecond, size: 20),
      filled: true,
      fillColor: c.inputFill,
      labelStyle: TextStyle(color: c.textSecond, fontSize: 13),
      hintStyle: TextStyle(color: c.textHint, fontSize: 13),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.divider)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.divider)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF5350))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5)),
    );
  }
}

// Password field with show/hide toggle
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  const _PasswordField(
      {required this.controller, required this.decoration, this.validator});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      decoration: widget.decoration.copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

class _EcgLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width * 0.44;
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final heart = Path();
    heart.moveTo(cx, cy + r * 0.85);
    heart.cubicTo(
        cx - r * 0.1, cy + r * 0.5, cx - r, cy + r * 0.3, cx - r, cy - r * 0.1);
    heart.cubicTo(
        cx - r, cy - r * 0.6, cx - r * 0.5, cy - r * 0.85, cx, cy - r * 0.4);
    heart.cubicTo(cx + r * 0.5, cy - r * 0.85, cx + r, cy - r * 0.6, cx + r,
        cy - r * 0.1);
    heart.cubicTo(
        cx + r, cy + r * 0.3, cx + r * 0.1, cy + r * 0.5, cx, cy + r * 0.85);
    heart.close();
    canvas.drawPath(heart, p);

    final ecg = Path();
    final y0 = cy + r * 0.08;
    ecg.moveTo(cx - r * 0.85, y0);
    ecg.lineTo(cx - r * 0.35, y0);
    ecg.lineTo(cx - r * 0.18, y0 - r * 0.38);
    ecg.lineTo(cx - r * 0.05, y0 + r * 0.42);
    ecg.lineTo(cx + r * 0.10, y0 - r * 0.65);
    ecg.lineTo(cx + r * 0.22, y0 + r * 0.30);
    ecg.lineTo(cx + r * 0.38, y0);
    ecg.lineTo(cx + r * 0.85, y0);
    canvas.drawPath(ecg, p..strokeWidth = 1.8);
  }

  @override
  bool shouldRepaint(_) => false;
}
