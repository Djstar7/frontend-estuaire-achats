import 'package:get/get.dart';
import '../../../data/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => cartItems.fold(0, (sum, item) {
        final price = item.product.price ?? 0;
        return sum + (price * item.quantity);
      });

  void addToCart(Product product, {int quantity = 1}) {
    final existingItem = cartItems.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );
    if (existingItem != null) {
      existingItem.quantity += quantity;
      cartItems.refresh();
      return;
    }
    cartItems.add(CartItem(product: product, quantity: quantity));
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final item = cartItems.firstWhereOrNull(
      (item) => item.product.id == productId,
    );
    if (item != null) {
      item.quantity = newQuantity;
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}
