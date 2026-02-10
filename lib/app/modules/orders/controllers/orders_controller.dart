import 'package:get/get.dart';
import '../../../data/models/order.dart';
import '../../../data/services/order_service.dart';

class OrdersController extends GetxController {
  final OrderService _orderService = Get.find();

  final orders = <Order>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      orders.assignAll(await _orderService.getMyOrders());
    } catch (e) {
      errorMessage.value = 'Impossible de charger les commandes.';
    } finally {
      isLoading.value = false;
    }
  }
}
