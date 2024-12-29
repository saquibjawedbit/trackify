import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timeController = TextEditingController();
    final isEnabled = true.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => SwitchListTile(
                  title: const Text('Daily Attendance Reminder'),
                  value: isEnabled.value,
                  onChanged: (value) => isEnabled.value = value,
                )),
            ListTile(
              title: const Text('Reminder Time'),
              subtitle: TextField(
                controller: timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select time for daily reminder',
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = '${time.hour}:${time.minute}';
                    await NotificationService().scheduleAttendanceReminder(
                      hour: time.hour,
                      minute: time.minute,
                      title: 'Attendance Reminder',
                      body: 'Don\'t forget to mark your attendance today!',
                    );
                    Get.snackbar(
                      'Success',
                      'Daily reminder scheduled for ${timeController.text}',
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
