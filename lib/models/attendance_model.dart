class AttendanceModel {
  final String subject;
  final double? requiredPercentage;
  final String? uid;
  int presentClasses;
  int absentClasses;
  int leaveClasses;

  AttendanceModel({
    required this.subject,
    this.requiredPercentage = 75.0,
    this.uid,
    this.presentClasses = 0,
    this.absentClasses = 0,
    this.leaveClasses = 0,
  });

  int get totalClasses => presentClasses + absentClasses + leaveClasses;

  double get attendancePercentage {
    if (totalClasses == 0) return 0;
    return (presentClasses / totalClasses) * 100;
  }

  bool get isPassing {
    if (requiredPercentage == null) return true;
    return attendancePercentage >= requiredPercentage!;
  }

  int classesNeededToPass() {
    if (requiredPercentage == null || isPassing) return 0;

    double required = requiredPercentage! / 100;
    int classesNeeded =
        ((required * totalClasses - presentClasses) / (1 - required)).ceil();
    return classesNeeded;
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'requiredPercentage': requiredPercentage,
      'presentClasses': presentClasses,
      'absentClasses': absentClasses,
      'leaveClasses': leaveClasses,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      subject: map['subject'],
      requiredPercentage: map['requiredPercentage'],
      presentClasses: map['presentClasses'],
      absentClasses: map['absentClasses'],
      leaveClasses: map['leaveClasses'],
      uid: map['uid'],
    );
  }
}
