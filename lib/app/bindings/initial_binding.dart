import 'package:get/get.dart';

import '../data/services/api_client.dart';
import '../data/services/auth_service.dart';
import '../data/services/category_service.dart';
import '../data/services/conversation_service.dart';
import '../data/services/like_service.dart';
import '../data/services/message_service.dart';
import '../data/services/order_service.dart';
import '../data/services/payment_service.dart';
import '../data/services/product_service.dart';
import '../data/services/seller_service.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../modules/categories/controllers/categories_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/products/controllers/products_controller.dart';
import '../modules/wishlist/controllers/wishlist_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);

    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<LikeService>(() => LikeService(), fenix: true);
    Get.lazyPut<SellerService>(() => SellerService(), fenix: true);
    Get.lazyPut<CategoryService>(() => CategoryService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<ConversationService>(() => ConversationService(), fenix: true);
    Get.lazyPut<MessageService>(() => MessageService(), fenix: true);
    Get.lazyPut<PaymentService>(() => PaymentService(), fenix: true);

    Get.put<ProductsController>(ProductsController(), permanent: true);
    Get.put<CategoriesController>(CategoriesController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<WishlistController>(WishlistController(), permanent: true);
  }
}
