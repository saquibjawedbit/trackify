import 'package:get/get.dart';
import '../models/attendance_model.dart';
import '../models/log_model.dart';
import 'attendance_list_controller.dart';

class AttendanceController extends GetxController {
  final attendance = Rx<AttendanceModel?>(null);
  final history = <LogModel>[].obs;

  void initAttendance(AttendanceModel attendance) {
    this.attendance.value = attendance;
  }

  void markAttendance(AttendanceType type, String reason, [DateTime? date]) {
    if (attendance.value == null) return;

    final log = LogModel(
      subjectId: attendance.value!.subject,
      type: type,
      reason: reason.isEmpty ? null : reason,
      date: date,
    );

    switch (type) {
      case AttendanceType.present:
        attendance.value!.presentClasses++;
        break;
      case AttendanceType.absent:
        attendance.value!.absentClasses++;
        history.add(log);
        break;
      case AttendanceType.leave:
        attendance.value!.leaveClasses++;
        history.add(log);
        break;
    }
    attendance.refresh();

    // Update the global attendance list
    final listController = Get.find<AttendanceListController>();
    listController.updateAttendance(attendance.value!);
  }
}
