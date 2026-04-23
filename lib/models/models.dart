// ═══════════════════════════════════════════════════════════════
//  SmartHealth — Data Models
//  كل الـ models في مكان واحد، جاهزة للباك اند
// ═══════════════════════════════════════════════════════════════

// ── User ─────────────────────────────────────────────────────
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String bloodType;
  final List<String> chronicDiseases;
  final List<String> allergies;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String memberSince;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    this.chronicDiseases = const [],
    this.allergies = const [],
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
    this.memberSince = '',
  });

  String get fullName => '$firstName $lastName';
}

// ── Vital Reading ────────────────────────────────────────────
class VitalReading {
  final String label;      // e.g. 'Blood Pressure'
  final String value;      // e.g. '120/80'
  final String unit;       // e.g. 'mmHg'
  final VitalStatus status;
  final String time;       // e.g. '2h ago'

  const VitalReading({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.time,
  });
}

enum VitalStatus { normal, warning, danger }

// ── Alert ────────────────────────────────────────────────────
class AlertModel {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final String time;
  final String? action;
  final AlertCategory category;

  const AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.action,
    required this.category,
  });
}

enum AlertType     { warning, success, danger, info }
enum AlertCategory { health, system }

// ── Session ──────────────────────────────────────────────────
class SessionModel {
  final String id;
  final String date;
  final String time;
  final String machineName;
  final String machineId;
  final String bp;        // Blood Pressure
  final String sugar;     // Blood Sugar
  final String pulse;     // Heart Rate
  final String temp;      // Temperature
  final String spo2;      // Oxygen Saturation
  final int healthScore;
  final SessionStatus status;
  final int daysAgo;

  const SessionModel({
    required this.id,
    required this.date,
    required this.time,
    required this.machineName,
    required this.machineId,
    required this.bp,
    required this.sugar,
    required this.pulse,
    required this.temp,
    required this.spo2,
    required this.healthScore,
    required this.status,
    required this.daysAgo,
  });
}

enum SessionStatus { normal, warning, danger }

// ── Machine ──────────────────────────────────────────────────
class MachineModel {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final bool isAvailable;

  const MachineModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.isAvailable,
  });
}

// ── Report ───────────────────────────────────────────────────
class ReportModel {
  final String id;
  final String title;
  final String date;
  final String sessionId;
  final int healthScore;
  final String summary;

  const ReportModel({
    required this.id,
    required this.title,
    required this.date,
    required this.sessionId,
    required this.healthScore,
    required this.summary,
  });
}
