import 'more_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
// import 'extra_screens.dart';
import 'support_chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Alex Johnson';
  String _email = 'alex.johnson@email.com';
  String _phone = '+1 (555) 234-5678';
  String _dob = 'January 15, 1985';
  String _gender = 'Male';
  String _emergName = 'Sarah Johnson';
  String _emergPhone = '+1 (555) 987-6543';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString(PrefKeys.profileName) ?? _name;
      _email = prefs.getString(PrefKeys.profileEmail) ?? _email;
      _phone = prefs.getString(PrefKeys.profilePhone) ?? _phone;
      _dob = prefs.getString(PrefKeys.profileDob) ?? _dob;
      _gender = prefs.getString(PrefKeys.profileGender) ?? _gender;
      _emergName = prefs.getString(PrefKeys.profileEmergName) ?? _emergName;
      _emergPhone = prefs.getString(PrefKeys.profileEmergPhone) ?? _emergPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: c.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: c.divider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportChatScreen()),
        ),
        backgroundColor: c.primary,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          BlueHeader(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25), width: 2),
                ),
                child: const Icon(Icons.person_outline,
                    color: Colors.white, size: 46),
              ),
              const SizedBox(height: 14),
              Text(_name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Member since Jan 2024',
                  style: TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()),
                  );

                  _loadProfile();
                },
                icon: const Icon(Icons.edit_outlined,
                    size: 16, color: Colors.white),
                label: const Text('Edit Profile',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
            ]),
          )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              SectionCard(title: 'Personal Information', children: [
                InfoDataRow(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    value: _name),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.email_outlined, label: 'Email', value: _email),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.phone_outlined, label: 'Phone', value: _phone),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.cake_outlined,
                    label: 'Date of Birth',
                    value: _dob),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.person_2_outlined,
                    label: 'Gender',
                    value: _gender),
              ]),
              const SizedBox(height: 14),
              SectionCard(title: 'Medical Information', children: [
                InfoDataRow(
                    icon: Icons.water_drop_outlined,
                    label: 'Blood Type',
                    value: 'O+',
                    iconColor: const Color(0xFFE53935)),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.add_outlined,
                    label: 'Chronic Diseases',
                    value: 'None',
                    iconColor: const Color(0xFF1976D2)),
              ]),
              const SizedBox(height: 14),
              SectionCard(title: 'Emergency Contact', children: [
                InfoDataRow(
                    icon: Icons.person_outline,
                    label: 'Contact Name',
                    value: _emergName),
                Divider(color: c.divider, height: 1),
                InfoDataRow(
                    icon: Icons.phone_outlined,
                    label: 'Contact Phone',
                    value: _emergPhone),
              ]),
              const SizedBox(height: 20),
              BluePrimaryButton(
                  label: 'Request Smart Card',
                  icon: Icons.credit_card_outlined,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SmartCardServicesScreen()),
                      )),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    await context.read<AppState>().logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (_) => false);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: c.alertErr),
                    foregroundColor: c.alertErr,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Text('Logout',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: c.alertErr)),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  EDIT PROFILE SCREEN
// ══════════════════════════════════════════════════════════════
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emergNameCtrl = TextEditingController();
  final _emergPhoneCtrl = TextEditingController();
  String _gender = 'Male';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameCtrl.text = prefs.getString(PrefKeys.profileName) ?? 'Alex Johnson';
      _emailCtrl.text =
          prefs.getString(PrefKeys.profileEmail) ?? 'alex.johnson@email.com';
      _phoneCtrl.text =
          prefs.getString(PrefKeys.profilePhone) ?? '+1 (555) 234-5678';
      _dobCtrl.text =
          prefs.getString(PrefKeys.profileDob) ?? 'January 15, 1985';
      _gender = prefs.getString(PrefKeys.profileGender) ?? 'Male';
      _emergNameCtrl.text =
          prefs.getString(PrefKeys.profileEmergName) ?? 'Sarah Johnson';
      _emergPhoneCtrl.text =
          prefs.getString(PrefKeys.profileEmergPhone) ?? '+1 (555) 987-6543';
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _emergNameCtrl.dispose();
    _emergPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.profileName, _nameCtrl.text.trim());
    await prefs.setString(PrefKeys.profileEmail, _emailCtrl.text.trim());
    await prefs.setString(PrefKeys.profilePhone, _phoneCtrl.text.trim());
    await prefs.setString(PrefKeys.profileDob, _dobCtrl.text.trim());
    await prefs.setString(PrefKeys.profileGender, _gender);
    await prefs.setString(
        PrefKeys.profileEmergName, _emergNameCtrl.text.trim());
    await prefs.setString(
        PrefKeys.profileEmergPhone, _emergPhoneCtrl.text.trim());
    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _deco(
    BuildContext context,
    String label,
    String hint,
    IconData icon,
  ) {
    final c = context.colors;
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
          borderSide: BorderSide(color: c.alertErr)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.alertErr, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: c.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary)),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: Text('Save',
                style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: c.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Avatar
            Center(
              child: Stack(children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: c.primary.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Icon(Icons.person_outline, color: c.primary, size: 46),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.scaffold, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 14),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            // Personal Info
            Text('Personal Information',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 14),

            TextFormField(
              controller: _nameCtrl,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(context, 'Full Name', 'Enter your full name',
                  Icons.person_outline),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(
                  context, 'Email', 'Enter your email', Icons.email_outlined),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(
                  context, 'Phone', 'Enter your phone', Icons.phone_outlined),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _dobCtrl,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(context, 'Date of Birth',
                  'e.g. January 15, 1985', Icons.cake_outlined),
            ),
            const SizedBox(height: 14),

            // Gender dropdown
            DropdownButtonFormField<String>(
              value: _gender,
              dropdownColor: c.card,
              style: TextStyle(color: c.textPrimary, fontSize: 14),
              decoration: _deco(context, 'Gender', '', Icons.person_2_outlined),
              items: ['Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 28),

            // Emergency Contact
            Text('Emergency Contact',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary)),
            const SizedBox(height: 14),

            TextFormField(
              controller: _emergNameCtrl,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(context, 'Contact Name', 'Enter contact name',
                  Icons.person_outline),
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _emergPhoneCtrl,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: c.textPrimary),
              decoration: _deco(context, 'Contact Phone', 'Enter contact phone',
                  Icons.phone_outlined),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: c.divider,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
