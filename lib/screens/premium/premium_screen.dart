import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/payment_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<ProductDetails> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final products = await PaymentService.fetchOffers();
      print('Fetched products: $products'); // Debugging
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching offers: $e'); // Debugging
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'Failed to load offers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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

  Widget _buildPricingButton(ProductDetails product,
      {bool isLifetime = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () async {
          try {
            await PaymentService.purchaseProduct(product);
            Get.back();
          } catch (e) {
            Get.snackbar(
              'Error',
              'Purchase failed: $e',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isLifetime ? Colors.amber : Colors.white24,
          foregroundColor: isLifetime ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isLifetime
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
                    product.id.contains('lifetime')
                        ? 'Lifetime Access'
                        : 'Monthly Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLifetime ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              product.price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isLifetime ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBar() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'Important Notice',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You are currently signed in as: ${user?.email}\n'
            'Please make sure to make the purchase with the same Google account '
            'to avoid any issues with premium access.',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionTerms() {
    String monthlyPrice =
        _products.isNotEmpty && _products.any((p) => !p.id.contains('lifetime'))
            ? _products.firstWhere((p) => !p.id.contains('lifetime')).price
            : 'Loading...';

    String lifetimePrice =
        _products.isNotEmpty && _products.any((p) => p.id.contains('lifetime'))
            ? _products.firstWhere((p) => p.id.contains('lifetime')).price
            : 'Loading...';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription Terms',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTermItem('Free Version Limitations',
              '• Limited to 7 subjects\n• Basic features only'),
          _buildTermItem('Monthly Subscription',
              '• $monthlyPrice/month\n• Auto-renews monthly\n• Cancel anytime\n• Full access to all features'),
          _buildTermItem('Lifetime Access',
              '• One-time payment of $lifetimePrice\n• Never expires\n• Full access to all features'),
          _buildTermItem('Premium Features',
              '• Unlimited subjects\n• AI-powered assistance\n• Cloud sync\n• Priority support'),
          const Divider(color: Colors.grey),
          const Text(
            'Important Information:',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Payment will be charged to your Google Play account\n'
            '• Subscription automatically renews unless auto-renew is turned off\n'
            '• Account will be charged for renewal within 24-hours prior to the end of the current period\n'
            '• You can manage your subscriptions in Google Play Store settings',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Features')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBar(), // Add info bar at the top
              // Premium features card
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
                      if (_isLoading)
                        const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                      else if (_products.isEmpty)
                        const Center(
                          child: Text(
                            'No offers available',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      else
                        ..._products.map((package) => _buildPricingButton(
                              package,
                              isLifetime: package.id.contains('lifetime'),
                            )),
                    ],
                  ),
                ),
              ),
              _buildSubscriptionTerms(), // Add subscription terms
            ],
          ),
        ),
      ),
    );
  }
}
