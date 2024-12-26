import 'package:f_star/screens/attendance/attendance_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel attendance;

  const AttendanceCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => AttendanceDetailScreen(
            attendanceModel: attendance,
          )),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 124,
                height: 124,
                padding: const EdgeInsets.all(12),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: attendance.attendancePercentage / 100,
                      backgroundColor: Colors.white,
                      color: Colors.green,
                      strokeWidth: 24,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${attendance.attendancePercentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      attendance.subject,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 24),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total Classes: ${attendance.totalClasses}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Present: ${attendance.presentClasses}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      'Leaves: ${attendance.leaveClasses}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.yellow[700],
                      ),
                    ),
                    Text(
                      'Absent: ${attendance.absentClasses}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[700],
                      ),
                    ),
                    if (!attendance.isPassing)
                      Text(
                        'Need ${attendance.classesNeededToPass()} more classes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
