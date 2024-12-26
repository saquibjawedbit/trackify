enum AttendanceType { present, absent, leave }

class LogModel {
  final String? uid;
  final DateTime date;
  final AttendanceType type;
  final String? reason;
  final String subjectId;

  LogModel({
    this.uid,
    required this.subjectId,
    required this.type,
    this.reason,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'type': type.toString(),
      'reason': reason,
      'subjectId': subjectId,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      uid: map['uid'],
      date: DateTime.parse(map['date']),
      type: AttendanceType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      reason: map['reason'],
      subjectId: map['subjectId'],
    );
  }

  // Helper method to get logs between date range
  static bool isInDateRange(LogModel log, DateTime start, DateTime end) {
    return log.date.isAfter(start) && log.date.isBefore(end);
  }

  // Helper method to get logs by type
  static bool isSameType(LogModel log, AttendanceType type) {
    return log.type == type;
  }
}
