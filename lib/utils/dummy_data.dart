import 'dart:math';
import '../models/attendance_model.dart';

class DummyData {
  static final Random _random = Random();

  static List<AttendanceModel> getDummyAttendance() {
    final subjects = [
      'Mathematics',
      'Physics',
      'Chemistry',
      'Computer Science',
      'English',
      'History',
    ];

    return subjects.map((subject) {
      final total = _random.nextInt(30) + 20; // 20-50 total classes
      final present = _random.nextInt(total);
      final leaves = _random.nextInt(total - present);
      final absent = total - present - leaves;

      return AttendanceModel(
        subject: subject,
        uid: 'dummy_${subject.toLowerCase().replaceAll(' ', '_')}',
        presentClasses: present,
        absentClasses: absent,
        leaveClasses: leaves,
        requiredPercentage: 75.0,
      );
    }).toList();
  }
}
