import 'dart:async';
import 'package:flutter/material.dart';

// ── Brand colours (stay the same in light & dark) ──────────────────────────
const _kBlue = Color(0xFF2196F3);
const _kBlueDark = Color(0xFF1565C0);
const _kGreen = Color(0xFF4CAF50);
const _kRed = Color(0xFFEF5350);

// ── Theme-aware colour helpers ──────────────────────────────────────────────
extension _Th on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get bg => isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
  Color get card => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get appBarBg => isDark ? const Color(0xFF1E1E1E) : Colors.white;

  // Borders / dividers
  Color get border =>
      isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

  // Text
  Color get textDark =>
      isDark ? const Color(0xFFF0F0F0) : const Color(0xFF1A1A2E);
  Color get textGrey =>
      isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
  Color get hintColor =>
      isDark ? const Color(0xFF616161) : const Color(0xFFBDBDBD);

  // Input field fill
  Color get fieldFill =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA);
}

// ══════════════════════════════════════════════════════════════
//  EMERGENCY QR SCREEN
// ══════════════════════════════════════════════════════════════
class EmergencyQrScreen extends StatelessWidget {
  const EmergencyQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: _kRed,
        foregroundColor: Colors.white,
        title: const Text('Emergency QR Code',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _kRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kRed.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.emergency_outlined, color: _kRed, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Show this QR code to emergency responders for immediate access to your health data.',
                  style: TextStyle(fontSize: 12, color: _kRed, height: 1.4),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          _Card(
            child: Column(children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: context.card,
                  border: Border.all(color: context.border, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    CustomPaint(painter: _QrPainter(color: context.textDark)),
              ),
              const SizedBox(height: 16),
              Text('EMERGENCY MEDICAL DATA',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.textDark,
                      letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text('Last updated: Today, 10:32 AM',
                  style: TextStyle(fontSize: 11, color: context.textGrey)),
            ]),
          ),
          const SizedBox(height: 16),
          _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Name',
                  value: 'Alex Johnson'),
              Divider(color: context.border, height: 16),
              _InfoRow(
                  icon: Icons.water_drop_outlined,
                  label: 'Blood Type',
                  value: 'O+',
                  iconColor: _kRed),
              Divider(color: context.border, height: 16),
              _InfoRow(
                  icon: Icons.medical_information_outlined,
                  label: 'Chronic Diseases',
                  value: 'None'),
              Divider(color: context.border, height: 16),
              _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Emergency Contact',
                  value: '+1 (555) 987-6543'),
            ]),
          ),
          const SizedBox(height: 16),
          _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Latest Vitals',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.textDark)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child:
                        _VitalMini(label: 'BP', value: '120/80', unit: 'mmHg')),
                Expanded(
                    child:
                        _VitalMini(label: 'Pulse', value: '72', unit: 'bpm')),
                Expanded(
                    child: _VitalMini(label: 'SpO₂', value: '98', unit: '%')),
                Expanded(
                    child:
                        _VitalMini(label: 'Temp', value: '36.5', unit: '°C')),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Share QR Code',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Save to Gallery',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kBlue,
                side: const BorderSide(color: _kBlue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

class _VitalMini extends StatelessWidget {
  final String label, value, unit;
  const _VitalMini(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 10, color: context.textGrey)),
      const SizedBox(height: 2),
      Text(value,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textDark)),
      Text(unit, style: TextStyle(fontSize: 9, color: context.textGrey)),
    ]);
  }
}

class _QrPainter extends CustomPainter {
  final Color color;
  const _QrPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final double cell = size.width / 10;
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 0],
      [1, 0, 0, 0, 0, 0, 1, 1, 1, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 0, 1, 1, 0, 1, 0],
      [0, 1, 0, 0, 1, 0, 1, 1, 0, 1],
    ];
    for (int r = 0; r < pattern.length; r++) {
      for (int c = 0; c < pattern[r].length; c++) {
        if (pattern[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell + 10, r * cell + 10, cell - 1, cell - 1),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.color != color;
}

// ══════════════════════════════════════════════════════════════
//  SUPPORT CHAT SCREEN
// ══════════════════════════════════════════════════════════════
class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_ChatMsg> _msgs = [
    _ChatMsg(
        text: "Hi! I'm your SmartHealth assistant. How can I help you today?",
        isBot: true,
        time: '10:30 AM'),
    _ChatMsg(
        text:
            "I can help you with machine locations, report downloads, card requests, and more.",
        isBot: true,
        time: '10:30 AM'),
  ];

  final _quickReplies = [
    'Where is the nearest machine?',
    'How to download my report?',
    'Request a Smart Card',
    'How to read my vitals?',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = (preset ?? _ctrl.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_ChatMsg(text: text, isBot: false, time: _now()));
      _ctrl.clear();
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _msgs
          .add(_ChatMsg(text: _botReply(text), isBot: true, time: _now())));
      _scrollToBottom();
    });
  }

  String _botReply(String msg) {
    final m = msg.toLowerCase();
    if (m.contains('machine') || m.contains('nearest'))
      return 'The nearest machine is at Central Health Hub, 0.3 km away. Go to the Machines tab to navigate there.';
    if (m.contains('report') || m.contains('download'))
      return 'You can download your report from the Vitals screen. Tap "Generate Report" then "Download PDF".';
    if (m.contains('card'))
      return 'To request a Smart Card, go to More → Card Management → Request Smart Card.';
    if (m.contains('vital') || m.contains('read'))
      return 'Your vitals are shown in the Vitals tab. Each reading includes a status (Normal/Warning/High) and a trend chart.';
    return "I'm here to help! You can ask me about machine locations, reports, your Smart Card, or how to use the app.";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final sfx = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $sfx';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        foregroundColor: context.textDark,
        elevation: 0,
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: _kBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
            child:
                const Icon(Icons.smart_toy_outlined, color: _kBlue, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('SmartHealth Assistant',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.textDark)),
            Text('Always available',
                style: TextStyle(fontSize: 11, color: context.textGrey)),
          ]),
        ]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: context.border, height: 1),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: _msgs.length,
            itemBuilder: (_, i) => _BubbleWidget(msg: _msgs[i]),
          ),
        ),
        if (_msgs.length <= 3)
          Container(
            color: context.appBarBg,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickReplies
                    .map((q) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _send(q),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _kBlue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _kBlue.withValues(alpha: 0.3)),
                              ),
                              child: Text(q,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: _kBlue,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: context.appBarBg,
            border: Border(top: BorderSide(color: context.border)),
          ),
          child: SafeArea(
            top: false,
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: TextStyle(fontSize: 14, color: context.textDark),
                  decoration: InputDecoration(
                    hintText: 'Ask about machines, reports, cards...',
                    hintStyle:
                        TextStyle(color: context.hintColor, fontSize: 13),
                    filled: true,
                    fillColor: context.fieldFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: context.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: context.border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: _kBlue, width: 1.5)),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _kBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: _kBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _BubbleWidget extends StatelessWidget {
  final _ChatMsg msg;
  const _BubbleWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            msg.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (msg.isBot) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: _kBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
              child:
                  const Icon(Icons.smart_toy_outlined, color: _kBlue, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  msg.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: msg.isBot ? context.card : _kBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
                      bottomRight: Radius.circular(msg.isBot ? 16 : 4),
                    ),
                    border:
                        msg.isBot ? Border.all(color: context.border) : null,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(msg.text,
                      style: TextStyle(
                          fontSize: 13,
                          color: msg.isBot ? context.textDark : Colors.white,
                          height: 1.4)),
                ),
                const SizedBox(height: 3),
                Text(msg.time,
                    style: TextStyle(fontSize: 10, color: context.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool isBot;
  final String time;
  _ChatMsg({required this.text, required this.isBot, required this.time});
}

// ══════════════════════════════════════════════════════════════
//  OTP SCREEN
// ══════════════════════════════════════════════════════════════
class OtpScreen extends StatefulWidget {
  final String phoneOrEmail;
  const OtpScreen({super.key, required this.phoneOrEmail});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 30;
  bool _canResend = false;
  bool _loading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendTimer == 0) {
        setState(() => _canResend = true);
        _timer?.cancel();
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _code => _ctrls.map((c) => c.text).join();
  bool get _isFilled => _code.length == 6;

  void _verify() async {
    if (!_isFilled) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.card,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [_kBlueDark, _kBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.lock_outline_rounded,
                          color: Colors.white, size: 34),
                    ),
                    const SizedBox(height: 12),
                    const Text('Verify Your Identity',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(children: [
              Text('Enter Verification Code',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textDark)),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14, color: context.textGrey, height: 1.4),
                  children: [
                    const TextSpan(text: 'A 6-digit code was sent to\n'),
                    TextSpan(
                        text: widget.phoneOrEmail,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.textDark)),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 46,
                    height: 56,
                    child: TextFormField(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.textDark),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: _ctrls[i].text.isNotEmpty
                            ? _kBlue.withValues(alpha: 0.08)
                            : context.fieldFill,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: context.border)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: context.border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _kBlue, width: 2)),
                      ),
                      onChanged: (val) {
                        setState(() {});
                        if (val.isNotEmpty && i < 5)
                          _nodes[i + 1].requestFocus();
                        else if (val.isEmpty && i > 0)
                          _nodes[i - 1].requestFocus();
                        if (_isFilled) _verify();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (_isFilled && !_loading) ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: context.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('Verify & Continue',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Didn't receive the code? ",
                    style: TextStyle(color: context.textGrey, fontSize: 14)),
                _canResend
                    ? GestureDetector(
                        onTap: _startTimer,
                        child: const Text('Resend',
                            style: TextStyle(
                                color: _kBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      )
                    : Text('Resend in ${_resendTimer}s',
                        style: TextStyle(
                            color: context.textGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  REQUEST SMART CARD SCREEN
// ══════════════════════════════════════════════════════════════
class RequestSmartCardScreen extends StatefulWidget {
  const RequestSmartCardScreen({super.key});
  @override
  State<RequestSmartCardScreen> createState() => _RequestSmartCardScreenState();
}

class _RequestSmartCardScreenState extends State<RequestSmartCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted)
      setState(() {
        _loading = false;
        _submitted = true;
      });
  }

  InputDecoration _deco(
      BuildContext context, String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: context.textGrey, size: 20),
      filled: true,
      fillColor: context.fieldFill,
      labelStyle: TextStyle(color: context.textGrey, fontSize: 13),
      hintStyle: TextStyle(color: context.hintColor, fontSize: 13),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBlue, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        foregroundColor: context.textDark,
        elevation: 0,
        title: Text('Request Smart Card',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: context.textDark)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.border, height: 1)),
      ),
      body: _submitted
          ? _SuccessView(onDone: () => Navigator.pop(context, true))
          : _FormView(
              formKey: _formKey,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              phoneCtrl: _phoneCtrl,
              addressCtrl: _addressCtrl,
              cityCtrl: _cityCtrl,
              loading: _loading,
              deco: _deco,
              onSubmit: _submit,
            ),
    );
  }
}

class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl,
      emailCtrl,
      phoneCtrl,
      addressCtrl,
      cityCtrl;
  final bool loading;
  final InputDecoration Function(BuildContext, String, String, IconData) deco;
  final VoidCallback onSubmit;

  const _FormView({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.loading,
    required this.deco,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kBlue.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBlue.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: _kBlue, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Your Smart Card gives you faster access to SmartHealth kiosks. Fill in your details below.',
                  style: TextStyle(fontSize: 12, color: _kBlue, height: 1.4),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Personal Information',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.textDark)),
          const SizedBox(height: 14),
          TextFormField(
              controller: nameCtrl,
              decoration: deco(context, 'Full Name', 'Enter your full name',
                  Icons.person_outline),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Full name is required'
                  : null),
          const SizedBox(height: 14),
          TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: deco(context, 'Email Address', 'Enter your email',
                  Icons.email_outlined),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              }),
          const SizedBox(height: 14),
          TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: deco(context, 'Phone Number',
                  'Enter your phone number', Icons.phone_outlined),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Phone number is required'
                  : null),
          const SizedBox(height: 24),
          Text('Delivery Address',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.textDark)),
          const SizedBox(height: 14),
          TextFormField(
              controller: addressCtrl,
              decoration: deco(context, 'Street Address',
                  'Enter your street address', Icons.home_outlined),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Address is required'
                  : null),
          const SizedBox(height: 14),
          TextFormField(
              controller: cityCtrl,
              decoration: deco(context, 'City', 'Enter your city',
                  Icons.location_city_outlined),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'City is required' : null),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: loading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: context.border,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text('Submit Request',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessView({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: _kGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: _kGreen, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Request Submitted!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.textDark)),
          const SizedBox(height: 12),
          Text(
            'Your Smart Card request has been received.\nWe\'ll process it and send it to your address within 5–7 business days.',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 14, color: context.textGrey, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  REPORT LOST CARD SCREEN
// ══════════════════════════════════════════════════════════════
class ReportLostCardScreen extends StatefulWidget {
  const ReportLostCardScreen({super.key});
  @override
  State<ReportLostCardScreen> createState() => _ReportLostCardScreenState();
}

class _ReportLostCardScreenState extends State<ReportLostCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted)
      setState(() {
        _loading = false;
        _submitted = true;
      });
  }

  InputDecoration _deco(
      BuildContext context, String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: context.textGrey, size: 20),
      filled: true,
      fillColor: context.fieldFill,
      labelStyle: TextStyle(color: context.textGrey, fontSize: 13),
      hintStyle: TextStyle(color: context.hintColor, fontSize: 13),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        foregroundColor: context.textDark,
        elevation: 0,
        title: Text('Report Lost Card',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: context.textDark)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.border, height: 1)),
      ),
      body: _submitted
          ? _LostSuccessView(onDone: () => Navigator.pop(context, true))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Warning banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _kRed.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: _kRed.withValues(alpha: 0.25)),
                        ),
                        child: const Row(children: [
                          Icon(Icons.warning_amber_rounded,
                              color: _kRed, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your card will be blocked immediately after submission to protect your health data.',
                              style: TextStyle(
                                  fontSize: 12, color: _kRed, height: 1.4),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      Text('Your Information',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textDark)),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _nameCtrl,
                          decoration: _deco(context, 'Full Name',
                              'Enter your full name', Icons.person_outline),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Full name is required'
                              : null),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _deco(context, 'Email Address',
                              'Enter your email', Icons.email_outlined),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Email is required';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          }),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: _deco(context, 'Phone Number',
                              'Enter your phone number', Icons.phone_outlined),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Phone number is required'
                              : null),
                      const SizedBox(height: 24),
                      Text('Additional Details',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textDark)),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: _deco(
                                context,
                                'Where did you lose it?',
                                'e.g. Lost at Central Mall yesterday',
                                Icons.location_on_outlined)
                            .copyWith(alignLabelWithHint: true),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kRed,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: context.border,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : const Text('Block Card & Report',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ]),
              ),
            ),
    );
  }
}

class _LostSuccessView extends StatelessWidget {
  final VoidCallback onDone;
  const _LostSuccessView({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: _kRed.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.credit_card_off_outlined,
                color: _kRed, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Card Blocked!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.textDark)),
          const SizedBox(height: 12),
          Text(
            'Your Smart Card has been blocked successfully.\nA replacement card request has been initiated and will arrive within 5–7 business days.',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 14, color: context.textGrey, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ══════════════════════════════════════════════════════════════
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border),
        boxShadow: [
          BoxShadow(
              color:
                  Colors.black.withValues(alpha: context.isDark ? 0.15 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color? iconColor;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: iconColor ?? _kBlue, size: 20),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: context.textGrey)),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textDark)),
      ]),
    ]);
  }
}
