import 'package:smarthealth/models/models.dart';

// ═══════════════════════════════════════════════════════════════
//  SmartHealth — Mock Data Service
//  كل البيانات الـ static في مكان واحد
//  لما يجي الباك اند، بس تبدل المحتوى هنا بـ API calls
// ═══════════════════════════════════════════════════════════════

class MockDataService {
  MockDataService._(); // prevent instantiation — use static only

  // ── Current User ───────────────────────────────────────────
  static const UserModel currentUser = UserModel(
    id: 'USR-001',
    firstName: 'Alex',
    lastName: 'Johnson',
    email: 'alex.johnson@email.com',
    phone: '+1 (555) 234-5678',
    dateOfBirth: 'January 15, 1985',
    gender: 'Male',
    bloodType: 'O+',
    chronicDiseases: [],
    allergies: [],
    emergencyContactName: 'Sarah Johnson',
    emergencyContactPhone: '+1 (555) 987-6543',
    memberSince: 'Jan 2024',
  );

  // ── Latest Vitals ──────────────────────────────────────────
  static const List<VitalReading> latestVitals = [
    VitalReading(
      label: 'Blood Pressure',
      value: '120/80',
      unit: 'mmHg',
      status: VitalStatus.normal,
      time: '2h ago',
    ),
    VitalReading(
      label: 'Heart Rate',
      value: '72',
      unit: 'bpm',
      status: VitalStatus.normal,
      time: '2h ago',
    ),
    VitalReading(
      label: 'SpO₂',
      value: '98',
      unit: '%',
      status: VitalStatus.normal,
      time: '2h ago',
    ),
    VitalReading(
      label: 'Blood Sugar',
      value: '110',
      unit: 'mg/dL',
      status: VitalStatus.normal,
      time: '2h ago',
    ),
    VitalReading(
      label: 'Temperature',
      value: '36.5',
      unit: '°C',
      status: VitalStatus.normal,
      time: '2h ago',
    ),
  ];

  // ── Alerts ─────────────────────────────────────────────────
  static List<AlertModel> get alerts => [
        const AlertModel(
          id: 'ALT-001',
          type: AlertType.warning,
          title: 'Elevated Temperature',
          message:
              'Your temperature reading of 37.8°C is slightly above normal.',
          time: 'Today, 11:20 AM',
          action: 'Monitor and rest',
          category: AlertCategory.health,
        ),
        const AlertModel(
          id: 'ALT-002',
          type: AlertType.success,
          title: 'Heart Rate Normal',
          message: 'Your heart rate is within the healthy range (72 bpm).',
          time: 'Today, 10:32 AM',
          category: AlertCategory.health,
        ),
        const AlertModel(
          id: 'ALT-003',
          type: AlertType.info,
          title: 'Machine Sync Complete',
          message: 'Your vitals have been synced with Machine #MH-042.',
          time: 'Today, 10:30 AM',
          category: AlertCategory.system,
        ),
        const AlertModel(
          id: 'ALT-004',
          type: AlertType.danger,
          title: 'Low SpO₂ Detected',
          message:
              'SpO₂ reading of 93% detected. Please consult a healthcare provider.',
          time: 'Yesterday, 3:15 PM',
          action: 'Seek medical advice',
          category: AlertCategory.health,
        ),
        const AlertModel(
          id: 'ALT-005',
          type: AlertType.warning,
          title: 'Machine Offline',
          message: 'Machine #MH-018 at Central Park is currently offline.',
          time: 'Yesterday, 1:00 PM',
          category: AlertCategory.system,
        ),
        const AlertModel(
          id: 'ALT-006',
          type: AlertType.info,
          title: 'Profile Updated',
          message: 'Your health profile was successfully updated.',
          time: '2 days ago',
          category: AlertCategory.system,
        ),
      ];

  // ── Sessions ───────────────────────────────────────────────
  static const List<SessionModel> sessions = [
    SessionModel(
      id: 'SES-001',
      date: 'Today',
      time: '10:32 AM',
      machineName: 'Central Health Hub',
      machineId: 'MH-042',
      bp: '120/80',
      sugar: '98',
      pulse: '72',
      temp: '36.5',
      spo2: '98',
      healthScore: 82,
      status: SessionStatus.normal,
      daysAgo: 0,
    ),
    SessionModel(
      id: 'SES-002',
      date: 'Yesterday',
      time: '2:15 PM',
      machineName: 'East Mall Station',
      machineId: 'MH-031',
      bp: '125/82',
      sugar: '105',
      pulse: '75',
      temp: '36.8',
      spo2: '97',
      healthScore: 78,
      status: SessionStatus.warning,
      daysAgo: 1,
    ),
    SessionModel(
      id: 'SES-003',
      date: 'Mar 19',
      time: '9:00 AM',
      machineName: 'North Community Center',
      machineId: 'MH-055',
      bp: '118/76',
      sugar: '92',
      pulse: '68',
      temp: '36.4',
      spo2: '99',
      healthScore: 88,
      status: SessionStatus.normal,
      daysAgo: 2,
    ),
    SessionModel(
      id: 'SES-004',
      date: 'Mar 15',
      time: '11:45 AM',
      machineName: 'Central Health Hub',
      machineId: 'MH-042',
      bp: '132/88',
      sugar: '118',
      pulse: '82',
      temp: '37.1',
      spo2: '96',
      healthScore: 65,
      status: SessionStatus.warning,
      daysAgo: 6,
    ),
    SessionModel(
      id: 'SES-005',
      date: 'Mar 10',
      time: '4:00 PM',
      machineName: 'Westside Clinic Kiosk',
      machineId: 'MH-018',
      bp: '145/95',
      sugar: '130',
      pulse: '90',
      temp: '37.4',
      spo2: '95',
      healthScore: 50,
      status: SessionStatus.danger,
      daysAgo: 11,
    ),
    SessionModel(
      id: 'SES-006',
      date: 'Mar 1',
      time: '8:30 AM',
      machineName: 'East Mall Station',
      machineId: 'MH-031',
      bp: '119/78',
      sugar: '96',
      pulse: '70',
      temp: '36.6',
      spo2: '98',
      healthScore: 85,
      status: SessionStatus.normal,
      daysAgo: 20,
    ),
  ];

  // ── Machines ───────────────────────────────────────────────
  static const List<MachineModel> machines = [
    MachineModel(
      id: 'MH-042',
      name: 'Central Health Hub',
      address: '123 Main St, Central Park',
      distanceKm: 0.3,
      isAvailable: true,
    ),
    MachineModel(
      id: 'MH-018',
      name: 'Westside Clinic Kiosk',
      address: 'Westside Clinic',
      distanceKm: 1.2,
      isAvailable: false,
    ),
    MachineModel(
      id: 'MH-031',
      name: 'East Mall Station',
      address: 'East Mall',
      distanceKm: 2.1,
      isAvailable: true,
    ),
    MachineModel(
      id: 'MH-055',
      name: 'North Community Center',
      address: 'North Community Center',
      distanceKm: 3.4,
      isAvailable: true,
    ),
  ];

  // ── Reports ────────────────────────────────────────────────
  static const List<ReportModel> reports = [
    ReportModel(
      id: 'RPT-001',
      title: 'Health Report — Today',
      date: 'Today, 10:32 AM',
      sessionId: 'SES-001',
      healthScore: 82,
      summary: 'All vitals within normal range. Keep up the good work!',
    ),
    ReportModel(
      id: 'RPT-002',
      title: 'Health Report — Yesterday',
      date: 'Yesterday, 2:15 PM',
      sessionId: 'SES-002',
      healthScore: 78,
      summary: 'Slight elevation in blood pressure. Monitor regularly.',
    ),
    ReportModel(
      id: 'RPT-003',
      title: 'Health Report — Mar 19',
      date: 'Mar 19, 9:00 AM',
      sessionId: 'SES-003',
      healthScore: 88,
      summary: 'Excellent results. All readings are optimal.',
    ),
  ];

  // ── Health Score ───────────────────────────────────────────
  static const int currentHealthScore = 82;
}
