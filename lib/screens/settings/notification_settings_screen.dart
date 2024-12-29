import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final timeController = TextEditingController();
  final isEnabled = true.obs;

  @override
  void initState() {
    super.initState();
    timeController.text = "18:00"; // Set default time to 6:00 PM
    loadTime();
    _scheduleDefaultNotification();
  }

  loadTime() async {
    timeController.text = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('notificationTime') ?? "18:00";
    });
  }

  Future<void> _scheduleDefaultNotification() async {
    await NotificationService().scheduleAttendanceReminder(
      hour: 18, // 6 PM
      minute: 0,
      title: 'Attendance Reminder',
      body: 'Don\'t forget to mark your attendance today!',
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    timeController.text =
                        '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

                    await SharedPreferences.getInstance().then((prefs) {
                      prefs.setString('notificationTime', timeController.text);
                    });

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
