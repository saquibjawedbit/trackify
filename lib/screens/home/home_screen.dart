import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_list_controller.dart';
import '../../components/attendance_card.dart';
import '../../models/attendance_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceListController = Get.find<AttendanceListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('F* Attendance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Obx(() {
              final overallAttendance = _calculateOverallAttendance(
                  attendanceListController.attendanceList);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade400,
                          Colors.green.shade400,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Overall Attendance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatistic(
                              'Average',
                              '${overallAttendance.toStringAsFixed(1)}%',
                              Icons.timeline,
                            ),
                            _buildStatistic(
                              'Subjects',
                              attendanceListController.attendanceList.length
                                  .toString(),
                              Icons.book,
                            ),
                            _buildStatistic(
                              'Status',
                              overallAttendance >= 75 ? 'Good' : 'At Risk',
                              overallAttendance >= 75
                                  ? Icons.thumb_up
                                  : Icons.warning,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AttendanceCard(
                          attendance:
                              attendanceListController.attendanceList[index],
                        ),
                      );
                    },
                    childCount: attendanceListController.attendanceList.length,
                  ),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new subject
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistic(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  double _calculateOverallAttendance(List<AttendanceModel> attendanceList) {
    if (attendanceList.isEmpty) return 0;

    double totalPercentage = attendanceList.fold(
      0,
      (sum, attendance) => sum + attendance.attendancePercentage,
    );

    return totalPercentage / attendanceList.length;
  }
}
