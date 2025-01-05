import 'package:f_star/controllers/log_controller.dart';
import 'package:f_star/screens/ai_chat/chat_with_ai_screen.dart';
import 'package:f_star/screens/attendance/attendance_detail_screen.dart';
import 'package:f_star/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_list_controller.dart';
import '../../components/attendance_card.dart';
import '../../models/attendance_model.dart';
import '../subject/add_subject_screen.dart';
import '../../controllers/premium_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceListController = Get.put(AttendanceListController());
    final premiumController = Get.put(PremiumController());
    Get.put(LogController());
    final isSelectionMode = false.obs;
    final selectedSubjects = <String>{}.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackify'),
        actions: [
          Obx(() => isSelectionMode.value
              ? Row(
                  children: [
                    Text('${selectedSubjects.length} selected'),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        isSelectionMode.value = false;
                        selectedSubjects.clear();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(
                        context,
                        attendanceListController,
                        selectedSubjects,
                        isSelectionMode,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      onPressed: () => isSelectionMode.value = true,
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => Get.to(() => const SettingsScreen()),
                    ),
                  ],
                )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: attendanceListController.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search subjects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatistic(
                                    'Average',
                                    '${overallAttendance.toStringAsFixed(1)}%',
                                    Icons.timeline,
                                  ),
                                  _buildStatistic(
                                    'Subjects',
                                    attendanceListController
                                        .attendanceList.length
                                        .toString(),
                                    Icons.book,
                                  ),
                                  _buildStatistic(
                                    'Status',
                                    overallAttendance >= 75
                                        ? 'Good'
                                        : 'At Risk',
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        premiumController.requirePremium(() {
                          Get.to(() => const ChatWithAiScreen());
                        });
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Ask with AI',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: Obx(() => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final subject = attendanceListController
                                .filteredAttendanceList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Obx(() => InkWell(
                                    onLongPress: () {
                                      if (!isSelectionMode.value) {
                                        isSelectionMode.value = true;
                                        selectedSubjects.add(subject.subject);
                                      }
                                    },
                                    onTap: () {
                                      if (isSelectionMode.value) {
                                        if (selectedSubjects
                                            .contains(subject.subject)) {
                                          selectedSubjects
                                              .remove(subject.subject);
                                          if (selectedSubjects.isEmpty) {
                                            isSelectionMode.value = false;
                                          }
                                        } else {
                                          selectedSubjects.add(subject.subject);
                                        }
                                      } else {
                                        Get.to(
                                          () => AttendanceDetailScreen(
                                            attendanceModel: subject,
                                          ),
                                        );
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        AttendanceCard(attendance: subject),
                                        if (isSelectionMode.value)
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Icon(
                                                  selectedSubjects.contains(
                                                          subject.subject)
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                          childCount: attendanceListController
                              .filteredAttendanceList.length,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        // final subjectCount = attendanceListController.attendanceList.length;
        final canAdd = attendanceListController.canAddMoreSubjects();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!canAdd)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Subject limit reached',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            FloatingActionButton(
              onPressed: canAdd
                  ? () => Get.to(() => AddSubjectScreen())
                  : () => Get.toNamed('/premium'),
              child: Icon(canAdd ? Icons.add : Icons.workspace_premium),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AttendanceListController controller,
    Set<String> selectedSubjects,
    RxBool isSelectionMode,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Subjects'),
        content: Text(
            'Are you sure you want to delete ${selectedSubjects.length} subjects?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (var uid in selectedSubjects) {
                controller.deleteSubject(
                  uid,
                );
              }
              isSelectionMode.value = false;
              selectedSubjects.clear();
              Get.back();
              Get.snackbar(
                'Success',
                'Subjects deleted successfully',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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

  Widget _buildPremiumBanner() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.deepPurple.shade600,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'Premium Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(Icons.chat_bubble, 'Natural Language Query (AI)'),
            const SizedBox(height: 8),
            _buildFeatureItem(Icons.cloud_sync, 'Unlimited Cloud Sync'),
            const SizedBox(height: 8),
            _buildFeatureItem(
                Icons.library_books, 'Unlimited Subject Creation'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
