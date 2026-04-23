import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

// ══════════════════════════════════════════════════════════════
//  FORGOT PASSWORD — 3-step flow
//  Step 1: Enter email/phone
//  Step 2: Verify OTP
//  Step 3: Set new password
// ══════════════════════════════════════════════════════════════

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 0; // 0 = email, 1 = OTP, 2 = new password

  // Step 1
  final _emailCtrl = TextEditingController();

  // Step 2
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpNodes = List.generate(6, (_) => FocusNode());
  int _resendTimer = 60;
  Timer? _timer;

  // Step 3
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final n in _otpNodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────
  void _startTimer() {
    setState(() => _resendTimer = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer == 0) {
        t.cancel();
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  bool get _otpFilled => _otpCtrls.every((c) => c.text.isNotEmpty);

  Future<void> _simulateLoading() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _loading = false);
  }

  // ── Step actions ──────────────────────────────────────────
  Future<void> _sendCode() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    await _simulateLoading();
    _startTimer();
    setState(() => _step = 1);
  }

  Future<void> _verifyOtp() async {
    if (!_otpFilled) return;
    await _simulateLoading();
    setState(() => _step = 2);
  }

  Future<void> _resetPassword() async {
    if (_passCtrl.text.isEmpty || _passCtrl.text != _confirmCtrl.text) return;
    await _simulateLoading();
    if (!mounted) return;
    // Success — go back to login
    await context.read<AppState>().logout();
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        onDone: () {
          Navigator.pop(context); // close dialog
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      body: Column(children: [
        // Blue header
        _Header(step: _step),

        // Steps indicator
        _StepsIndicator(current: _step),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _step == 0
                  ? _EmailStep(
                      key: const ValueKey(0),
                      ctrl: _emailCtrl,
                      loading: _loading,
                      onNext: _sendCode,
                      onBack: () => Navigator.pop(context),
                    )
                  : _step == 1
                      ? _OtpStep(
                          key: const ValueKey(1),
                          email: _emailCtrl.text.trim(),
                          ctrls: _otpCtrls,
                          nodes: _otpNodes,
                          loading: _loading,
                          otpFilled: _otpFilled,
                          resendTimer: _resendTimer,
                          onVerify: _verifyOtp,
                          onResend: _sendCode,
                          onBack: () => setState(() => _step = 0),
                        )
                      : _NewPasswordStep(
                          key: const ValueKey(2),
                          passCtrl: _passCtrl,
                          confirmCtrl: _confirmCtrl,
                          loading: _loading,
                          onReset: _resetPassword,
                          onBack: () => setState(() => _step = 1),
                        ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  BLUE HEADER
// ══════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final int step;
  const _Header({required this.step});

  static const _titles = [
    'Forgot Password',
    'Verify Code',
    'New Password',
  ];
  static const _subs = [
    'Enter your registered email or phone',
    'Enter the 6-digit code we sent you',
    'Create a strong new password',
  ];
  static const _icons = [
    Icons.lock_reset_outlined,
    Icons.mark_email_read_outlined,
    Icons.lock_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(children: [
            // Back button row
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            // Icon circle
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Icon(_icons[step], color: Colors.white, size: 34),
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Column(
                key: ValueKey(step),
                children: [
                  Text(_titles[step],
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(_subs[step],
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STEPS INDICATOR
// ══════════════════════════════════════════════════════════════
class _StepsIndicator extends StatelessWidget {
  final int current;
  const _StepsIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.card,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Row(children: [
              // Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? c.primary
                      : active
                          ? c.primary
                          : c.scaffold,
                  border: Border.all(
                    color: (done || active) ? c.primary : c.divider,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: active ? Colors.white : c.textHint)),
                ),
              ),
              // Line
              if (i < 2)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    color: i < current ? c.primary : c.divider,
                  ),
                ),
            ]),
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STEP 1 — EMAIL / PHONE
// ══════════════════════════════════════════════════════════════
class _EmailStep extends StatelessWidget {
  final TextEditingController ctrl;
  final bool loading;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _EmailStep({
    super.key,
    required this.ctrl,
    required this.loading,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 28),

      Text('Registered Email or Phone',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: c.textSecond)),
      const SizedBox(height: 20),

      AppTextField(
        label: 'Email or Phone Number',
        hint: 'Enter your email or phone',
        controller: ctrl,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 12),

      // Info note
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: const Color(0xFF2196F3).withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF2196F3), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'We\'ll send a 6-digit verification code to reset your password.',
              style: TextStyle(fontSize: 12, color: c.textSecond, height: 1.4),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 32),

      loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)))
          : BluePrimaryButton(label: 'Send Code', onTap: onNext),

      const SizedBox(height: 16),
      Center(
        child: GestureDetector(
          onTap: onBack,
          child: Text('Back to Login',
              style: TextStyle(
                  fontSize: 14, color: c.primary, fontWeight: FontWeight.w600)),
        ),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════
//  STEP 2 — OTP VERIFY
// ══════════════════════════════════════════════════════════════
class _OtpStep extends StatelessWidget {
  final String email;
  final List<TextEditingController> ctrls;
  final List<FocusNode> nodes;
  final bool loading;
  final bool otpFilled;
  final int resendTimer;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onBack;

  const _OtpStep({
    super.key,
    required this.email,
    required this.ctrls,
    required this.nodes,
    required this.loading,
    required this.otpFilled,
    required this.resendTimer,
    required this.onVerify,
    required this.onResend,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      const SizedBox(height: 28),

      // Sent to
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.divider),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.send_outlined,
                color: Color(0xFF2196F3), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Code sent to',
                  style: TextStyle(fontSize: 11, color: c.textSecond)),
              Text(
                email.isNotEmpty ? email : 'your contact',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 28),

      // OTP boxes
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) {
          return _OtpBox(
            ctrl: ctrls[i],
            node: nodes[i],
            nextNode: i < 5 ? nodes[i + 1] : null,
            prevNode: i > 0 ? nodes[i - 1] : null,
          );
        }),
      ),
      const SizedBox(height: 32),

      loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)))
          : BluePrimaryButton(
              label: 'Verify Code',
              onTap: otpFilled ? onVerify : () {},
            ),

      const SizedBox(height: 20),

      // Resend
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Didn't receive the code? ",
            style: TextStyle(color: c.textSecond, fontSize: 14)),
        resendTimer == 0
            ? GestureDetector(
                onTap: onResend,
                child: const Text('Resend',
                    style: TextStyle(
                        color: Color(0xFF2196F3),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              )
            : Text('Resend in ${resendTimer}s',
                style: TextStyle(
                    color: c.textHint,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
      ]),
      const SizedBox(height: 16),
      Center(
        child: GestureDetector(
          onTap: onBack,
          child: Text('Change Email / Phone',
              style: TextStyle(
                  fontSize: 13,
                  color: c.textSecond,
                  decoration: TextDecoration.underline)),
        ),
      ),
    ]);
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode node;
  final FocusNode? nextNode;
  final FocusNode? prevNode;
  const _OtpBox(
      {required this.ctrl, required this.node, this.nextNode, this.prevNode});

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final filled = widget.ctrl.text.isNotEmpty;
    final focused = widget.node.hasFocus;

    return SizedBox(
      width: 46,
      height: 54,
      child: TextFormField(
        controller: widget.ctrl,
        focusNode: widget.node,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: c.textPrimary),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: filled
              ? const Color(0xFF2196F3).withValues(alpha: 0.08)
              : c.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: filled ? const Color(0xFF2196F3) : c.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
        ),
        onChanged: (val) {
          setState(() {});
          if (val.isNotEmpty) {
            widget.nextNode?.requestFocus();
          } else {
            widget.prevNode?.requestFocus();
          }
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STEP 3 — NEW PASSWORD
// ══════════════════════════════════════════════════════════════
class _NewPasswordStep extends StatefulWidget {
  final TextEditingController passCtrl;
  final TextEditingController confirmCtrl;
  final bool loading;
  final VoidCallback onReset;
  final VoidCallback onBack;

  const _NewPasswordStep({
    super.key,
    required this.passCtrl,
    required this.confirmCtrl,
    required this.loading,
    required this.onReset,
    required this.onBack,
  });

  @override
  State<_NewPasswordStep> createState() => _NewPasswordStepState();
}

class _NewPasswordStepState extends State<_NewPasswordStep> {
  bool _match = true;

  void _validate() {
    setState(() {
      _match = widget.passCtrl.text == widget.confirmCtrl.text ||
          widget.confirmCtrl.text.isEmpty;
    });
  }

  // Password strength
  int _strength(String p) {
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final strength = _strength(widget.passCtrl.text);
    final strengthColor = [
      c.divider,
      const Color(0xFFEF5350),
      const Color(0xFFFFA726),
      const Color(0xFF66BB6A),
      const Color(0xFF4CAF50),
    ][strength];
    const strengthLabel = ['', 'Weak', 'Fair', 'Good', 'Strong'];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 28),

      AppTextField(
        label: 'New Password',
        hint: 'Enter new password',
        isPassword: true,
        controller: widget.passCtrl,
      ),
      const SizedBox(height: 10),

      // Strength bar
      if (widget.passCtrl.text.isNotEmpty) ...[
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: strength / 4,
                backgroundColor: c.divider,
                valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(strengthLabel[strength],
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: strengthColor)),
        ]),
        const SizedBox(height: 6),
        // Requirements
        _Req(
            met: widget.passCtrl.text.length >= 8,
            label: 'At least 8 characters'),
        _Req(
            met: widget.passCtrl.text.contains(RegExp(r'[A-Z]')),
            label: 'One uppercase letter'),
        _Req(
            met: widget.passCtrl.text.contains(RegExp(r'[0-9]')),
            label: 'One number'),
        const SizedBox(height: 4),
      ],

      const SizedBox(height: 14),

      AppTextField(
        label: 'Confirm Password',
        hint: 'Re-enter new password',
        isPassword: true,
        controller: widget.confirmCtrl,
      ),

      // Match error
      if (!_match) ...[
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF5350), size: 14),
          const SizedBox(width: 6),
          Text("Passwords don't match",
              style: const TextStyle(fontSize: 12, color: Color(0xFFEF5350))),
        ]),
      ],

      const SizedBox(height: 32),

      widget.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)))
          : StatefulBuilder(
              builder: (_, set) => BluePrimaryButton(
                label: 'Reset Password',
                onTap: () {
                  _validate();
                  if (_match &&
                      widget.passCtrl.text.isNotEmpty &&
                      widget.confirmCtrl.text.isNotEmpty) {
                    widget.onReset();
                  }
                },
              ),
            ),
    ]);
  }
}

class _Req extends StatelessWidget {
  final bool met;
  final String label;
  const _Req({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 14,
          color: met ? const Color(0xFF4CAF50) : c.textHint,
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: met ? const Color(0xFF4CAF50) : c.textSecond)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SUCCESS DIALOG
// ══════════════════════════════════════════════════════════════
class _SuccessDialog extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessDialog({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF4CAF50), size: 40),
          ),
          const SizedBox(height: 18),
          const Text('Password Reset!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Your password has been changed successfully. You can now log in with your new password.',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Back to Login',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}
