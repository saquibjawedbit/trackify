import 'package:f_star/screens/settings/notification_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../premium/premium_screen.dart';
import '../../controllers/attendance_list_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'simplex.gamestudio@egmail.com', // Replace with your email
        queryParameters: {
          'subject': 'Feature Request',
          'body': 'I would like to request a feature...'
        });

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  void _handleDeleteAllRecords() async {
    final controller = Get.find<AttendanceListController>();

    Get.defaultDialog(
      title: 'Delete All Records',
      middleText:
          'Are you sure you want to delete all attendance records and logs? This action cannot be undone.',
      textConfirm: 'Delete All',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // Close dialog
        await controller.deleteAllRecords();
      },
    );
  }

  Widget _buildCancellationGuide() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cancel_outlined, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'How to Cancel Subscription',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCancellationStep(
              '1',
              'Open Google Play Store',
              'Tap the Play Store icon on your device',
            ),
            _buildCancellationStep(
              '2',
              'Access Account Settings',
              'Tap your profile icon → Payments & subscriptions',
            ),
            _buildCancellationStep(
              '3',
              'Find Subscriptions',
              'Tap "Subscriptions"',
            ),
            _buildCancellationStep(
              '4',
              'Select Trackify',
              'Find and tap on Trackify in your subscriptions list',
            ),
            _buildCancellationStep(
              '5',
              'Cancel Subscription',
              'Tap "Cancel subscription" and follow the steps',
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Note: You\'ll continue to have premium access until the end of your current billing period.',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancellationStep(
      String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.star, color: primaryColor),
            title: const Text('Request Feature'),
            onTap: _launchEmail,
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: Icon(Icons.workspace_premium, color: primaryColor),
            title: const Text('Premium'),
            onTap: () => Get.to(() => const PremiumScreen()),
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: Icon(Icons.notifications, color: primaryColor),
            title: const Text('Notifications'),
            onTap: () => Get.to(() => const NotificationSettingsScreen()),
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: Icon(Icons.logout, color: primaryColor),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete your Account',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              'All attendance records logs and user data will be deleted permanently',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _handleDeleteAllRecords,
          ),
          Divider(color: primaryColor),
          const Divider(),
          ExpansionTile(
            leading: Icon(Icons.help_outline, color: primaryColor),
            title: const Text('Cancel Subscription'),
            children: [
              _buildCancellationGuide(),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
