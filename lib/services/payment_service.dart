import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static bool isPremium = false;
  static List<ProductDetails> _products = [];
  static Stream<List<PurchaseDetails>>? _purchaseStream;

  /// Initialize the payment service
  static Future<void> init() async {
    await checkPremiumStatus(); // Check if premium is already unlocked

    _purchaseStream = _iap.purchaseStream;
    _listenToPurchases();

    bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint("In-App Purchase is not available");
      return;
    }

    await fetchOffers();
    await restorePurchases();
  }

  /// Fetch available product offers
  static Future<List<ProductDetails>> fetchOffers() async {
    const Set<String> _kProductIds = {'prem_10_1m', 'prem_99_lifetime'};
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kProductIds);

    if (response.error != null || response.notFoundIDs.isNotEmpty) {
      debugPrint("Error fetching offers: ${response.error}");
      Get.snackbar(
        'Error',
        'Failed to load premium offers',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }

    _products = response.productDetails;
    return _products;
  }

  /// Purchase a product
  static Future<bool> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (e) {
      debugPrint("Error purchasing product: $e");
      Get.snackbar(
        'Error',
        'Purchase failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Listen for purchase updates
  static void _listenToPurchases() {
    _iap.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      for (var purchase in purchaseDetailsList) {
        debugPrint("Purchase detected: ${purchase.status}");

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _verifyPurchase(purchase);
        } else if (purchase.status == PurchaseStatus.error) {
          debugPrint("Purchase error: ${purchase.error?.message}");
        }
      }
    }, onError: (error) {
      debugPrint("Error in purchase stream: $error");
    });
  }

  /// Verify and complete the purchase
  static Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }

    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      isPremium = true;

      // Persist the premium status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremium', true);

      debugPrint("Premium unlocked successfully!");
    }
  }

  /// Check if the user is already premium (persisted data)
  static Future<void> checkPremiumStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool('isPremium') ?? false;

    debugPrint("Checked premium status: $isPremium");
  }

  /// Restore purchases for users who reinstall the app
  static Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint("Error restoring purchases: $e");
    }
  }
}
