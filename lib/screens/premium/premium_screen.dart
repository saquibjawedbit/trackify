import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingButton({
    required String title,
    required String price,
    required String description,
    required VoidCallback onPressed,
    bool isRecommended = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isRecommended ? Colors.amber : Colors.white24,
          foregroundColor: isRecommended ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isRecommended
                ? const BorderSide(color: Colors.amber, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isRecommended ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isRecommended ? Colors.black54 : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isRecommended ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                          Icon(Icons.workspace_premium,
                              color: Colors.amber, size: 32),
                          SizedBox(width: 12),
                          Text(
                            'Unlock Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureItem(
                        Icons.chat_bubble,
                        'Natural Language Query (AI)\nAsk questions in plain language',
                      ),
                      _buildFeatureItem(
                        Icons.cloud_sync,
                        'Unlimited Cloud Sync\nAccess your data anywhere',
                      ),
                      _buildFeatureItem(
                        Icons.library_books,
                        'Unlimited Subject Creation\nTrack all your subjects',
                      ),
                      _buildFeatureItem(
                        Icons.priority_high,
                        'Priority Feature Requests\nGet your features implemented first',
                      ),
                      const SizedBox(height: 24),
                      _buildPricingButton(
                        title: 'Lifetime Access',
                        price: '₹99',
                        description: 'One-time payment, forever access',
                        onPressed: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Lifetime subscription will be available soon!',
                            backgroundColor: Colors.amber,
                            colorText: Colors.black,
                            dismissDirection: DismissDirection.horizontal,
                          );
                        },
                        isRecommended: true,
                      ),
                      _buildPricingButton(
                        title: 'Monthly',
                        price: '₹10',
                        description: 'Billed monthly, cancel anytime',
                        onPressed: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Monthly subscription will be available soon!',
                            backgroundColor: Colors.amber,
                            colorText: Colors.black,
                            dismissDirection: DismissDirection.horizontal,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
