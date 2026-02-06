import 'package:get/get.dart';
import 'product_controller.dart';
import 'cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  late ProductController productController;
  late CartController cartController;
  late AuthController authController;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    productController = Get.put(ProductController());
    cartController = Get.put(CartController());
    authController = Get.find<AuthController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  String getUserName() {
    return authController.userName.isNotEmpty ? authController.userName : 'Utilisateur';
  }
}
