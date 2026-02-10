import 'package:get/get.dart';
import '../../../data/models/seller.dart';
import '../../../data/services/seller_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../products/controllers/products_controller.dart';

class HomeController extends GetxController {
  late ProductsController productController;
  late CartController cartController;
  late AuthController authController;
  late SellerService sellerService;
  final count = 0.obs;
  final topSellers = <Seller>[].obs;
  final isLoadingTopSellers = false.obs;
  final topSellersError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    productController = Get.find<ProductsController>();
    cartController = Get.find<CartController>();
    authController = Get.find<AuthController>();
    sellerService = Get.find<SellerService>();
    loadTopSellers();
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

  Future<void> loadTopSellers() async {
    try {
      isLoadingTopSellers.value = true;
      topSellersError.value = '';
      topSellers.assignAll(await sellerService.getTopSellers());
    } catch (e) {
      topSellersError.value = 'Impossible de charger les vendeurs.';
    } finally {
      isLoadingTopSellers.value = false;
    }
  }
}
