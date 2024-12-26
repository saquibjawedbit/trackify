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
}
