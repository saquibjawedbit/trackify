import 'package:f_star/controllers/premium_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  static final _apiKey = dotenv.env['APP_PURCHASE_API_KEY'];
  static bool isPremium = false;

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey!);

    configuration.appUserID = uid;

    await Purchases.configure(configuration);

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // print('CustomerInfo: ${customerInfo}');
      isPremium = customerInfo.entitlements.active.isNotEmpty;
      debugPrint('CustomerInfo: ${customerInfo}');
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
      Get.snackbar(
        'Error',
        'Failed to load premium status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<List<Package>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      if (current == null) {
        debugPrint('No offerings available');
        return [];
      }

      return current.availablePackages;
    } catch (e) {
      debugPrint('Error fetching offers: $e');
      Get.snackbar(
        'Error',
        'Failed to load premium offers',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      final premium = customerInfo.entitlements.active.isNotEmpty;
      isPremium = premium;
      final PremiumController controller = Get.find();
      controller.checkPremiumStatus();
      return isPremium;
    } catch (e) {
      debugPrint('Error purchasing package: $e');
      Get.snackbar(
        'Error',
        'Purchase failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
