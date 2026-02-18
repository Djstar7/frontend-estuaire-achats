import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../../data/services/order_service.dart';
import '../../../data/models/order.dart';

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
  final OrderService _orderService = Get.find();

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => cartItems.fold(0, (sum, item) {
        final price = item.product.price ?? 0;
        return sum + (price * item.quantity);
      });

  int _availableStock(Product product) {
    return product.quantity ?? 0;
  }

  void _syncQuantitiesWithStock() {
    var didAdjust = false;
    cartItems.removeWhere((item) {
      final stock = _availableStock(item.product);
      if (stock <= 0) {
        didAdjust = true;
        return true;
      }
      if (item.quantity > stock) {
        item.quantity = stock;
        didAdjust = true;
      }
      return false;
    });

    if (didAdjust) {
      cartItems.refresh();
      Get.snackbar(
        'Stock',
        'Certaines quantites ont ete ajustees au stock disponible.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addToCart(Product product, {int quantity = 1}) {
    final stock = _availableStock(product);
    if (stock <= 0) {
      Get.snackbar(
        'Stock',
        'Produit indisponible.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final existingItem = cartItems.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );
    if (existingItem != null) {
      final desired = existingItem.quantity + quantity;
      final clamped = desired > stock ? stock : desired;
      existingItem.quantity = clamped;
      cartItems.refresh();
      if (clamped < desired) {
        Get.snackbar(
          'Stock',
          'Quantite ajustee au stock disponible.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }
    final clamped = quantity > stock ? stock : quantity;
    cartItems.add(CartItem(product: product, quantity: clamped));
    if (clamped < quantity) {
      Get.snackbar(
        'Stock',
        'Quantite ajustee au stock disponible.',
        snackPosition: SnackPosition.BOTTOM,
      );
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

    final item = cartItems.firstWhereOrNull(
      (item) => item.product.id == productId,
    );
    if (item != null) {
      final stock = _availableStock(item.product);
      if (stock <= 0) {
        removeFromCart(productId);
        Get.snackbar(
          'Stock',
          'Produit indisponible.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (newQuantity > stock) {
        item.quantity = stock;
        Get.snackbar(
          'Stock',
          'Quantite ajustee au stock disponible.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        item.quantity = newQuantity;
      }
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  /// Creates an order from the current cart items
  Future<Order> createOrderFromCart({
    // required String deliveryAddress,
    String currency = 'XAF',
    String? notes,
    String? paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      throw Exception('Le panier est vide');
    }

    _syncQuantitiesWithStock();
    if (cartItems.isEmpty) {
      throw Exception('Aucun produit disponible en stock.');
    }

    final items = cartItems
        .map((item) => {
          'product_id': item.product.id,
          'quantity': item.quantity,
        })
        .where((item) => item['product_id'] != null)
        .toList();

    final orderData = {
      'items': items,
      // 'delivery_address': deliveryAddress,
      'currency': currency.toUpperCase(),
      if (notes != null) 'notes': notes,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    };

    final order = await _orderService.createOrder(orderData);
    
    // Clear the cart after successful order creation
    clearCart();
    
    return order;
  }

  /// Creates multiple orders from the current cart items
  Future<List<Order>> createOrdersFromCart({
    // required String deliveryAddress,
    String currency = 'XAF',
    String? notes,
    String? paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      throw Exception('Le panier est vide');
    }

    _syncQuantitiesWithStock();
    if (cartItems.isEmpty) {
      throw Exception('Aucun produit disponible en stock.');
    }

    final items = cartItems
        .map((item) => {
          'product_id': item.product.id,
          'quantity': item.quantity,
        })
        .where((item) => item['product_id'] != null)
        .toList();

    final orderData = {
      'items': items,
      // 'delivery_address': deliveryAddress,
      'currency': currency.toUpperCase(),
      if (notes != null) 'notes': notes,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    };

    final orders = await _orderService.createOrders(orderData);
    
    // Clear the cart after successful order creation
    clearCart();
    
    return orders;
  }

  /// Creates an order for a single product directly (without adding to cart)
  Future<Order> createDirectOrder({
    required int productId,
    required int quantity,
    // required String deliveryAddress,
    String currency = 'XAF',
    String? notes,
    String? paymentMethod,
  }) async {
    if (productId <= 0 || quantity <= 0) {
      throw Exception('Produit ID et quantité doivent être valides');
    }

    final orderData = {
      'items': [
        {
          'product_id': productId,
          'quantity': quantity,
        }
      ],
      // 'delivery_address': deliveryAddress,
      'currency': currency.toUpperCase(),
      if (notes != null) 'notes': notes,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    };

    return await _orderService.createOrder(orderData);
  }
}
