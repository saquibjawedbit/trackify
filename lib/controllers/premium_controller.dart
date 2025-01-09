import 'package:f_star/services/payment_service.dart';
import 'package:get/get.dart';

class PremiumController extends GetxController {
  final _isPremium = false.obs;
  bool get isPremium => _isPremium.value;

  @override
  void onInit() {
    super.onInit();
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    try {
      _isPremium.value = PaymentService.isPremium;
    } catch (e) {
      _isPremium.value = false;
    }
  }

  void requirePremium(Function callback) {
    checkPremiumStatus();
    if (isPremium) {
      callback();
    } else {
      Get.toNamed('/premium');
    }
  }
}
