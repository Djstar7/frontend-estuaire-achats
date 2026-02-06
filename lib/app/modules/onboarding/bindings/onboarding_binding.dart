import 'package:frontend_estuaire_achats/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}