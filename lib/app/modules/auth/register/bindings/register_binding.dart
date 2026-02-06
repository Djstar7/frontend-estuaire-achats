import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../controllers/auth_controller.dart'; // Importer le AuthController

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
    // S'assurer que le AuthController est également disponible
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
  }
}
