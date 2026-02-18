import 'package:frontend_estuaire_achats/app/data/models/user.dart';
import 'package:frontend_estuaire_achats/app/data/models/product.dart';

class OrderItem {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;
  final Product? product;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.replaceAll(',', '.'));
      return null;
    }

    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: parsePrice(json['unit_price'] ?? json['price']),
      totalPrice: parsePrice(json['total_price']),
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      // 'unit_price': unitPrice,
      'total_amount': totalPrice,
      'product': product?.toJson(),
    };
  }
}

class Order {
  final int? id;
  final int? userId;
  final int? sellerId;
  final String? status;
  final double? totalAmount;
  final String? currency;
  final String? deliveryAddress;
  final String? notes;
  final String? paymentMethod;
  final String? paymentStatus;
  final List<OrderItem>? items;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    this.userId,
    this.sellerId,
    this.status,
    this.totalAmount,
    this.currency,
    this.deliveryAddress,
    this.notes,
    this.paymentMethod,
    this.paymentStatus,
    this.items,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.replaceAll(',', '.'));
      return null;
    }

    return Order(
      id: json['id'],
      userId: json['user_id'],
      sellerId: json['seller_id'],
      status: json['status'],
      totalAmount: parsePrice(json['total_amount']),
      currency: json['currency'],
      deliveryAddress: json['delivery_address'],
      notes: json['notes'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      items: json['items'] != null 
          ? List<OrderItem>.from(json['items'].map((item) => OrderItem.fromJson(item))) 
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'seller_id': sellerId,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
      'delivery_address': deliveryAddress,
      'notes': notes,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'items': items?.map((item) => item.toJson()).toList(),
      'user': user?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
