import 'package:get/get.dart';
import 'product_controller.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => cartItems.fold(0, (sum, item) {
    double itemPrice = item.product.isOnSale && item.product.salePrice != null
        ? item.product.salePrice!
        : item.product.price;
    return sum + (itemPrice * item.quantity);
  });

  void addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    var item = cartItems.firstWhereOrNull((item) => item.product.id == productId);
    if (item != null) {
      item.quantity = newQuantity;
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}