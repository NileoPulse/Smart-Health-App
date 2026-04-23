import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── SmartHealth Top App Bar ──────────────────────────────────
class SmartHealthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;
  const SmartHealthAppBar({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.star_border_rounded, color: c.primary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('SmartHealth',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: c.textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: c.divider),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outline, color: c.textSecond, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: c.divider),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}

// ── Blue gradient header ─────────────────────────────────────
class BlueHeader extends StatelessWidget {
  final Widget child;
  final double? height;
  const BlueHeader({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

// ── Text field ───────────────────────────────────────────────
class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key, required this.label, required this.hint,
    this.isPassword = false, this.controller, this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          style: TextStyle(fontSize: 15, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: c.textHint),
            filled: true,
            fillColor: c.inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.divider)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.primary, width: 1.5)),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: c.textSecond, size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Blue full-width button ───────────────────────────────────
class BluePrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  const BluePrimaryButton({super.key, required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ── Status badge ─────────────────────────────────────────────
enum StatusType { normal, warning, danger, info }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;
  const StatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color bg, text;
    switch (type) {
      case StatusType.normal:  bg = c.normalBg;  text = c.normalText;
      case StatusType.warning: bg = c.warningBg; text = c.warningText;
      case StatusType.danger:  bg = c.dangerBg;  text = c.dangerText;
      case StatusType.info:    bg = c.infoBg;    text = c.infoText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text)),
    );
  }
}

// ── Bottom nav bar ───────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const items = [
      _NavItem(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,            label: 'Home'),
      _NavItem(icon: Icons.star_border_rounded,    activeIcon: Icons.star_rounded,            label: 'Vitals'),
      _NavItem(icon: Icons.notifications_outlined, activeIcon: Icons.notifications_rounded,   label: 'Alerts'),
      _NavItem(icon: Icons.monitor_outlined,       activeIcon: Icons.monitor_rounded,         label: 'Machines'),
      _NavItem(icon: Icons.more_horiz,             activeIcon: Icons.more_horiz,              label: 'More'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final sel = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(sel ? items[i].activeIcon : items[i].icon,
                        color: sel ? c.primary : c.textSecond, size: 24),
                    const SizedBox(height: 2),
                    Text(items[i].label, style: TextStyle(
                      fontSize: 11,
                      color: sel ? c.primary : c.textSecond,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                    )),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

// ── Info row ─────────────────────────────────────────────────
class InfoDataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  const InfoDataRow({super.key, required this.icon, required this.label, required this.value, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Icon(icon, color: iconColor ?? c.primary, size: 20),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 13, color: c.textSecond)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.textPrimary)),
        ]),
      ]),
    );
  }
}

// ── Section card wrapper ─────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: c.textPrimary)),
        const SizedBox(height: 8),
        ...children,
      ]),
    );
  }
}

// ── Settings row (toggle or arrow) ───────────────────────────
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final bool showArrow;
  final bool last;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.toggleValue,
    this.onToggle,
    this.showArrow = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(children: [
            Icon(icon, color: c.primary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label,
                style: TextStyle(fontSize: 15, color: c.textPrimary))),
            if (toggleValue != null)
              Switch(
                value: toggleValue!,
                onChanged: onToggle,
                activeColor: c.primary,
              )
            else if (showArrow)
              Icon(Icons.chevron_right, color: c.textSecond),
          ]),
        ),
        if (!last) Divider(height: 1, color: c.divider),
      ],
    );
  }
}

// ── Health Assistant overlay ──────────────────────────────────
class HealthAssistantOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const HealthAssistantOverlay({super.key, required this.onClose});

  @override
  State<HealthAssistantOverlay> createState() => _HealthAssistantOverlayState();
}

class _HealthAssistantOverlayState extends State<HealthAssistantOverlay> {
  final _ctrl       = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping    = false;

  final List<_ChatMsg> _msgs = [
    _ChatMsg(text: "Hi! I'm your SmartHealth assistant 👋\nHow can I help you today?", isBot: true),
  ];

  static const _botReplies = [
    "Based on your latest vitals, everything looks normal! Keep up the good work 💪",
    "Your blood pressure (120/80) is within the healthy range. Stay hydrated!",
    "I recommend maintaining your current routine. Your health score is 82/100 ⭐",
    "Your SpO₂ is at 98% which is excellent! Keep breathing fresh air 🌿",
    "Try to get 7–8 hours of sleep for optimal health. Your heart rate looks great!",
  ];
  int _replyIndex = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
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

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_ChatMsg(text: text, isBot: false));
      _ctrl.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _msgs.add(_ChatMsg(
          text: _botReplies[_replyIndex % _botReplies.length],
          isBot: true,
        ));
        _replyIndex++;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_outlined,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Health Assistant',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text(
                  _isTyping ? 'typing...' : 'Online',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11),
                ),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ]),
          ),

          // ── Messages ────────────────────────────────────────
          SizedBox(
            height: 220,
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(12),
              itemCount: _msgs.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _msgs.length) {
                  return const _TypingIndicator();
                }
                return _BubbleWidget(msg: _msgs[i]);
              },
            ),
          ),

          // ── Input ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.divider)),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: TextStyle(fontSize: 14, color: c.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Ask about your health...',
                    hintStyle: TextStyle(color: c.textHint, fontSize: 13),
                    filled: true,
                    fillColor: c.scaffold,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: c.divider)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: c.divider)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(
                            color: const Color(0xFF2196F3), width: 1.5)),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Typing indicator (3 animated dots) ───────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    ));
    _anims = _ctrls
        .map((c) => Tween<double>(begin: 0, end: -6).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _ctrls[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: c.scaffold,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.divider),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _anims[i],
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _anims[i].value),
              child: Container(
                width: 7, height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        })),
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool isBot;
  _ChatMsg({required this.text, required this.isBot});
}

class _BubbleWidget extends StatelessWidget {
  final _ChatMsg msg;
  const _BubbleWidget({required this.msg});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Align(
      alignment: msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: msg.isBot ? c.scaffold : const Color(0xFF2196F3),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
            bottomRight: Radius.circular(msg.isBot ? 16 : 4),
          ),
          border: msg.isBot ? Border.all(color: c.divider) : null,
        ),
        child: Text(msg.text,
            style: TextStyle(
                fontSize: 13,
                color: msg.isBot ? c.textPrimary : Colors.white,
                height: 1.4)),
      ),
    );
  }
}
