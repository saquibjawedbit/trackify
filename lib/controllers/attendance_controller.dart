import 'package:flutter/material.dart';
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
    ever(attendance, (_) async {
      if (attendance.value != null) {
        final logs =
            await logController.getLogsForSubject(attendance.value!.subject);
        history.value = logs;
      }
    });
  }

  void initAttendance(AttendanceModel attendance) {
    this.attendance.value = attendance;
  }

  Future<void> markAttendance(AttendanceType type, String reason,
      [DateTime? date]) async {
    if (attendance.value == null) return;

    try {
      final log = LogModel(
        subjectId: attendance.value!.subject,
        type: type,
        reason: reason.isEmpty ? null : reason,
        date: date,
      );

      // Save log to Firestore first
      await log.saveToFirestore();

      // Update local history immediately
      history.insert(0, log); // Add to beginning of list since it's newest
      history.refresh(); // Force UI update

      // Update attendance counts
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

      // Save attendance changes
      attendance.refresh();
      final listController = Get.find<AttendanceListController>();
      await listController.updateAttendance(attendance.value!);
      await attendance.value!.saveToFirestore();

      // Refresh logs from Firestore to ensure consistency
      final updatedLogs =
          await logController.getLogsForSubject(attendance.value!.subject);
      history.value = updatedLogs;
      history.refresh();

      Get.snackbar(
        'Success',
        'Attendance marked as ${type.toString().split('.').last}',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark attendance: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> updateAttendanceCounts({
    required int present,
    required int absent,
    required int leaves,
  }) async {
    if (attendance.value == null) return;

    try {
      attendance.value!.presentClasses = present;
      attendance.value!.absentClasses = absent;
      attendance.value!.leaveClasses = leaves;

      // Save to Firestore
      await attendance.value!.saveToFirestore();

      // Update local state
      attendance.refresh();

      // Update list controller
      final listController = Get.find<AttendanceListController>();
      await listController.updateAttendance(attendance.value!);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update attendance: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> deleteLogs(List<String> logIds) async {
    for (var id in logIds) {
      await LogModel.deleteLog(id);
    }
    history.removeWhere((log) => logIds.contains(log.id));

    await _updateAttendanceCounts();
    await saveAttendance();
  }

  Future<void> _updateAttendanceCounts() async {
    if (attendance.value == null) return;

    int present = 0;
    int absent = 0;
    int leaves = 0;

    final logs =
        await logController.getLogsForSubject(attendance.value!.subject);
    for (var log in logs) {
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

    await updateAttendanceCounts(
      present: present,
      absent: absent,
      leaves: leaves,
    );
  }

  Future<void> saveAttendance() async {
    if (attendance.value != null) {
      await attendance.value!.saveToFirestore();
    }
  }
}
