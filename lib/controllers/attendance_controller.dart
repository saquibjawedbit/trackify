import 'package:get/get.dart';
import '../models/attendance_model.dart';
import '../models/log_model.dart';
import 'attendance_list_controller.dart';
import 'log_controller.dart';

class AttendanceController extends GetxController {
  final attendance = Rx<AttendanceModel?>(null);
  final logController = Get.find<LogController>();
  final history = <LogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(attendance, (_) {
      if (attendance.value != null) {
        history.value =
            logController.getLogsForSubject(attendance.value!.subject);
      }
    });
  }

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

    logController.addLog(log);
    history.add(log);

    switch (type) {
      case AttendanceType.present:
        attendance.value!.presentClasses++;
        break;
      case AttendanceType.absent:
        attendance.value!.absentClasses++;
        break;
      case AttendanceType.leave:
        attendance.value!.leaveClasses++;
        break;
    }
    attendance.refresh();

    final listController = Get.find<AttendanceListController>();
    listController.updateAttendance(attendance.value!);
  }

  void updateAttendanceCounts({
    required int present,
    required int absent,
    required int leaves,
  }) {
    if (attendance.value == null) return;

    attendance.value!.presentClasses = present;
    attendance.value!.absentClasses = absent;
    attendance.value!.leaveClasses = leaves;
    attendance.refresh();

    final listController = Get.find<AttendanceListController>();
    listController.updateAttendance(attendance.value!);
  }

  void deleteLogs(List<String> logIds) {
    history.removeWhere((log) {
      if (logIds.contains(log.id)) {
        print("Found");
        return true;
      }

      return false;
    });
    for (var id in logIds) {
      logController.deleteLog(id);
    } // Use forEach instead of map
    _updateAttendanceCounts();
    saveAttendance();
  }

  void _updateAttendanceCounts() {
    if (attendance.value == null) return;

    int present = 0;
    int absent = 0;
    int leaves = 0;

    for (var log in history) {
      switch (log.type) {
        case AttendanceType.present:
          present++;
          break;
        case AttendanceType.absent:
          absent++;
          break;
        case AttendanceType.leave:
          leaves++;
          break;
      }
    }

    updateAttendanceCounts(
      present: present,
      absent: absent,
      leaves: leaves,
    );
  }

  void saveAttendance() {
    if (attendance.value != null) {
      final listController = Get.find<AttendanceListController>();
      listController.updateAttendance(attendance.value!);
    }
  }
}
