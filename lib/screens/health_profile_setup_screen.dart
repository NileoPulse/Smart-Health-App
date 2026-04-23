import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HealthProfileSetupScreen extends StatefulWidget {
  final String firstName;
  const HealthProfileSetupScreen({super.key, required this.firstName});

  @override
  State<HealthProfileSetupScreen> createState() =>
      _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends State<HealthProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Required
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String? _bloodType;

  // Optional
  final List<String> _availableDiseases = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'Thyroid',
    'Kidney Disease',
    'Anemia',
    'Arthritis',
  ];
  final Set<String> _selectedDiseases = {};

  final List<String> _availableAllergies = [
    'Penicillin',
    'Aspirin',
    'Pollen',
    'Dust',
    'Latex',
    'Nuts',
    'Shellfish',
    'Gluten',
  ];
  final Set<String> _selectedAllergies = {};

  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  String? _preferredLang;

  bool _loading = false;

  static const _bloodTypes = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
  static const _languages = [
    'English',
    'Arabic',
    'French',
    'Spanish',
    'German'
  ];

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bloodType == null) {
      _showSnack('Please select your blood type');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      await context.read<AppState>().login();
      setState(() => _loading = false);
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF2196F3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Form(
        key: _formKey,
        child: Column(children: [
          // ── Progress header ──────────────────────────────────
          _ProgressHeader(firstName: widget.firstName),

          // ── Scrollable form ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ════════════════════════════════════════════
                  // SECTION 1 — Body Measurements (Required)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.monitor_weight_outlined,
                    title: 'Body Measurements',
                    subtitle: 'Required for accurate health scoring',
                    isRequired: true,
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    Row(children: [
                      Expanded(
                        child: _NumericField(
                          label: 'Height',
                          hint: '170',
                          unit: 'cm',
                          controller: _heightCtrl,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Required';
                            final n = double.tryParse(v);
                            if (n == null || n < 50 || n > 250)
                              return '50–250 cm';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _NumericField(
                          label: 'Weight',
                          hint: '70',
                          unit: 'kg',
                          controller: _weightCtrl,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Required';
                            final n = double.tryParse(v);
                            if (n == null || n < 10 || n > 300)
                              return '10–300 kg';
                            return null;
                          },
                        ),
                      ),
                    ]),
                  ]),

                  const SizedBox(height: 20),

                  // ════════════════════════════════════════════
                  // SECTION 2 — Blood Type (Required)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.water_drop_outlined,
                    title: 'Blood Type',
                    subtitle: 'Used in emergency situations',
                    isRequired: true,
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _bloodTypes.map((bt) {
                        final sel = _bloodType == bt;
                        return GestureDetector(
                          onTap: () => setState(() => _bloodType = bt),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  sel ? const Color(0xFF2196F3) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFFE0E0E0),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              bt,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Optional divider ─────────────────────────
                  _OptionalDivider(),
                  const SizedBox(height: 20),

                  // ════════════════════════════════════════════
                  // SECTION 3 — Chronic Diseases (Optional)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.medical_information_outlined,
                    title: 'Chronic Diseases',
                    subtitle: 'Select all that apply',
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableDiseases.map((d) {
                        final sel = _selectedDiseases.contains(d);
                        return FilterChip(
                          label: Text(d),
                          selected: sel,
                          onSelected: (v) => setState(() {
                            v
                                ? _selectedDiseases.add(d)
                                : _selectedDiseases.remove(d);
                          }),
                          selectedColor:
                              const Color(0xFF2196F3).withOpacity(0.15),
                          checkmarkColor: const Color(0xFF2196F3),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: sel
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF424242),
                            fontWeight:
                                sel ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: sel
                                ? const Color(0xFF2196F3)
                                : const Color(0xFFE0E0E0),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                        );
                      }).toList(),
                    ),
                    if (_selectedDiseases.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        '${_selectedDiseases.length} selected',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF2196F3)),
                      ),
                    ],
                  ]),

                  const SizedBox(height: 20),

                  // ════════════════════════════════════════════
                  // SECTION 4 — Allergies (Optional)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.warning_amber_outlined,
                    title: 'Known Allergies',
                    subtitle: 'Select all that apply',
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableAllergies.map((a) {
                        final sel = _selectedAllergies.contains(a);
                        return FilterChip(
                          label: Text(a),
                          selected: sel,
                          onSelected: (v) => setState(() {
                            v
                                ? _selectedAllergies.add(a)
                                : _selectedAllergies.remove(a);
                          }),
                          selectedColor:
                              const Color(0xFFFFA726).withOpacity(0.15),
                          checkmarkColor: const Color(0xFFF57C00),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: sel
                                ? const Color(0xFFF57C00)
                                : const Color(0xFF424242),
                            fontWeight:
                                sel ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: sel
                                ? const Color(0xFFFFA726)
                                : const Color(0xFFE0E0E0),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                        );
                      }).toList(),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ════════════════════════════════════════════
                  // SECTION 5 — Emergency Contact (Optional)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.emergency_outlined,
                    title: 'Emergency Contact',
                    subtitle: 'Shown on your Smart Card in emergencies',
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    _SimpleField(
                      label: 'Contact Name',
                      hint: 'Full name',
                      controller: _emergencyNameCtrl,
                    ),
                    const SizedBox(height: 14),
                    _SimpleField(
                      label: 'Contact Phone',
                      hint: '+1 234 567 8900',
                      controller: _emergencyPhoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ════════════════════════════════════════════
                  // SECTION 6 — Preferred Language (Optional)
                  // ════════════════════════════════════════════
                  _SectionHeader(
                    icon: Icons.translate_outlined,
                    title: 'Preferred Language',
                    subtitle: 'For reports and notifications',
                  ),
                  const SizedBox(height: 14),
                  _WhiteCard(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _preferredLang,
                          isExpanded: true,
                          hint: const Text('Select language',
                              style: TextStyle(
                                  color: Color(0xFFBDBDBD), fontSize: 14)),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF9E9E9E)),
                          items: _languages
                              .map((l) => DropdownMenuItem(
                                    value: l,
                                    child: Text(l,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF1A1A2E))),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _preferredLang = v),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // ── Save & Continue ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27)),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Save & Continue',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Skip for now ─────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        await context.read<AppState>().login();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/main', (_) => false);
                        }
                      },
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Progress header ──────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final String firstName;
  const _ProgressHeader({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              Row(children: [
                _StepDot(active: true, done: true, label: '1'),
                _StepLine(active: true),
                _StepDot(active: true, done: false, label: '2'),
                _StepLine(active: false),
                _StepDot(active: false, done: false, label: '3'),
              ]),
              const SizedBox(height: 14),
              Text(
                'Hi $firstName! 👋',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'Complete your health profile for accurate results',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final bool done;
  final String label;
  const _StepDot(
      {required this.active, required this.done, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check_rounded,
                size: 16, color: Color(0xFF2196F3))
            : Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: active ? const Color(0xFF2196F3) : Colors.white,
                )),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;
  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: active ? Colors.white : Colors.white.withOpacity(0.3),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isRequired;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF2196F3), size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E))),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(' *',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF5350))),
            ],
          ]),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
        ]),
      ),
    ]);
  }
}

// ── White card wrapper ───────────────────────────────────────
class _WhiteCard extends StatelessWidget {
  final List<Widget> children;
  const _WhiteCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

// ── Numeric input with unit ──────────────────────────────────
class _NumericField extends StatelessWidget {
  final String label;
  final String hint;
  final String unit;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _NumericField({
    required this.label,
    required this.hint,
    required this.unit,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242))),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        validator: validator,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E)),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
          suffixText: unit,
          suffixStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEF5350)),
          ),
        ),
      ),
    ]);
  }
}

// ── Simple text field ────────────────────────────────────────
class _SimpleField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _SimpleField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242))),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
          ),
        ),
      ),
    ]);
  }
}

// ── Optional section divider ─────────────────────────────────
class _OptionalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBBDEFB)),
        ),
        child: const Text(
          'Optional fields',
          style: TextStyle(
              fontSize: 12,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w500),
        ),
      ),
      const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
    ]);
  }
}
