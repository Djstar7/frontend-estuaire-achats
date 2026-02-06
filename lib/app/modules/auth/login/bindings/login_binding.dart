import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../controllers/auth_controller.dart'; // Importer le AuthController

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    // S'assurer que le AuthController est également disponible
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
  }
}
