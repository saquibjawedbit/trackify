import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'your.email@example.com', // Replace with your email
        queryParameters: {
          'subject': 'Feature Request',
          'body': 'I would like to request a feature...'
        });

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
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
            onTap: () {
              // Handle premium settings
            },
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: Icon(Icons.notifications, color: primaryColor),
            title: const Text('Notifications'),
            onTap: () {
              // Handle notification settings
            },
          ),
          Divider(color: primaryColor),
          ListTile(
            leading: Icon(Icons.logout, color: primaryColor),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.toNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
