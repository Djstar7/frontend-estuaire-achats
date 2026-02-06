import 'package:frontend_estuaire_achats/app/modules/auth/controllers/auth_controller.dart';
import 'package:frontend_estuaire_achats/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  late AuthController authController;
  
  // Flag pour empêcher les exécutions multiples
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController(), permanent: true);
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Utilisation d'un délai avec vérification du flag de sécurité
    Future.delayed(const Duration(seconds: 2), () {
      if (!_hasNavigated) {
        checkUserStatus();
      }
    });
  }

  void checkUserStatus() {
    if (_hasNavigated) return; // Sécurité supplémentaire
    _hasNavigated = true;

    // IMPORTANT : On utilise Get.offAllNamed pour s'assurer que le Splash 
    // et ses timers sont supprimés de la pile de navigation.
    if (!authController.isFirstTime) {
      Get.offAllNamed(Routes.HOME);
    } else {
      // Assure-toi que Routes.ONBOARDING correspond bien à '/onboarding'
      Get.offAllNamed('/onboarding'); 
    }
  }

  void increment() => count.value++;

  final count = 0.obs;
  
  @override
  void onClose() {
    super.onClose();
  }
}