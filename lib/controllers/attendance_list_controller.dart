import 'package:f_star/controllers/log_controller.dart';
import 'package:get/get.dart';
import '../models/attendance_model.dart';

class AttendanceListController extends GetxController {
  final attendanceList = <AttendanceModel>[].obs;

  void updateAttendance(AttendanceModel updatedAttendance) {
    final index =
        attendanceList.indexWhere((a) => a.uid == updatedAttendance.uid);
    if (index != -1) {
      attendanceList[index] = updatedAttendance;
      attendanceList.refresh();
    }
  }

  void addSubject(AttendanceModel subject) {
    attendanceList.add(subject);
    attendanceList.refresh();
  }

  void deleteSubject(String uid) {
    final subject = attendanceList.firstWhere((s) => s.uid == uid);
    attendanceList.removeWhere((s) => s.uid == uid);

    // Delete associated logs
    final logController = Get.find<LogController>();
    logController.deleteLogs(subject.subject);

    attendanceList.refresh();
  }
}
