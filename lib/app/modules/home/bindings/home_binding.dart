import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
