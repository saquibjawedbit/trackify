import 'package:f_star/models/attendance_model.dart';
import 'package:f_star/models/log_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final AttendanceModel attendanceModel;

  const AttendanceDetailScreen({
    super.key,
    required this.attendanceModel,
  });

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  final attendanceController = Get.put(AttendanceController());

  @override
  void initState() {
    super.initState();
    attendanceController.initAttendance(widget.attendanceModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.attendanceModel.subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final attendance = attendanceController.attendance.value;
          if (attendance == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataMap = {
            "Present": attendance.presentClasses.toDouble(),
            "Absent": attendance.absentClasses.toDouble(),
            "Leaves": attendance.leaveClasses.toDouble(),
          };

          final colorMap = <String, Color>{
            "Present": Colors.green,
            "Absent": Colors.red,
            "Leaves": Colors.yellow,
          };

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subject Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        Text('Subject Code: ${attendance.uid ?? "N/A"}'),
                        Text(
                            'Required Attendance: ${attendance.requiredPercentage}%'),
                        Text(
                            'Current Attendance: ${attendance.attendancePercentage.toStringAsFixed(1)}%'),
                        if (!attendance.isPassing)
                          Text(
                            'Classes needed to pass: ${attendance.classesNeededToPass()}',
                            style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Statistics',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _buildStatRow('Total Classes', attendance.totalClasses),
                        _buildStatRow(
                            'Present', attendance.presentClasses, Colors.green),
                        _buildStatRow(
                            'Absent', attendance.absentClasses, Colors.red),
                        _buildStatRow(
                            'Leaves', attendance.leaveClasses, Colors.yellow),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    dataMap: dataMap,
                    colorList: colorMap.values.toList(),
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                    legendOptions: const LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _btn(
                      onTap: () => {
                        attendanceController.markAttendance(
                          AttendanceType.present,
                          '',
                        )
                      },
                      color: Colors.green,
                      text: "Mark Present",
                    ),
                    _btn(
                      onTap: () async {
                        final reason =
                            await _showReasonDialog(context, 'Absent');
                        if (reason != null) {
                          attendanceController.markAttendance(
                            AttendanceType.absent,
                            reason,
                          );
                        }
                      },
                      color: Colors.red,
                      text: "Mark Absent",
                    ),
                    _btn(
                      onTap: () async {
                        final reason =
                            await _showReasonDialog(context, 'Leave');
                        if (reason != null) {
                          attendanceController.markAttendance(
                            AttendanceType.leave,
                            reason,
                          );
                        }
                      },
                      color: const Color.fromARGB(255, 62, 59, 17),
                      text: "Mark Leave",
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Attendance History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                SizedBox(
                  height: 200,
                  child: Obx(() => ListView.builder(
                        itemCount: attendanceController.history.length,
                        itemBuilder: (context, index) {
                          final log = attendanceController.history[index];
                          return ListTile(
                            title: Text('${log.type}: ${log.reason}'),
                            subtitle: Text(log.date.toString()),
                          );
                        },
                      )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  GestureDetector _btn(
      {required Function()? onTap,
      required Color color,
      required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (label != 'Total Classes') // Don't show edit for total
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () => _showEditDialog(context, label, value),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, String type, int currentValue) async {
    final controller = TextEditingController(text: currentValue.toString());

    return Get.dialog(
      AlertDialog(
        title: Text('Edit $type'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: type,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newValue = int.tryParse(controller.text);
              if (newValue != null && newValue >= 0) {
                final attendance = attendanceController.attendance.value!;

                int present = attendance.presentClasses;
                int absent = attendance.absentClasses;
                int leaves = attendance.leaveClasses;

                switch (type) {
                  case 'Present':
                    present = newValue;
                    break;
                  case 'Absent':
                    absent = newValue;
                    break;
                  case 'Leaves':
                    leaves = newValue;
                    break;
                }

                attendanceController.updateAttendanceCounts(
                  present: present,
                  absent: absent,
                  leaves: leaves,
                );
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showReasonDialog(BuildContext context, String type) async {
    TextEditingController reasonController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return Get.dialog<String>(
      AlertDialog(
        title: Text('Mark $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                  (context as Element).markNeedsBuild();
                }
              },
            ),
            const Divider(),
            const SizedBox(
              height: 4,
            ),
            TextField(
              controller: reasonController,
              maxLength: 80,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter reason (optional)',
                counterText: '${reasonController.text.length}/80',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(
              result:
                  '${selectedDate.toIso8601String()}|${reasonController.text}',
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
