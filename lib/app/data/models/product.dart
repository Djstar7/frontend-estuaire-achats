import 'package:frontend_estuaire_achats/app/data/models/user.dart';

class Product {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final int? quantity;
  final int? categoryId;
  final int? sellerId;
  final User? seller;
  final List<String>? images;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.categoryId,
    this.sellerId,
    this.seller,
    this.images,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value.replaceAll(',', '.'));
      }
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    List<String>? parseImages(dynamic value) {
      if (value == null) return null;
      if (value is String && value.isNotEmpty) return [value];
      if (value is List) {
        final urls = <String>[];
        for (final item in value) {
          if (item is String && item.isNotEmpty) {
            urls.add(item);
          } else if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            final url = map['url'] ?? map['path'] ?? map['image_url'] ?? map['image'];
            if (url is String && url.isNotEmpty) {
              urls.add(url);
            }
          }
        }
        return urls.isEmpty ? null : urls;
      }
      return null;
    }

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: parsePrice(json['price']),
      quantity: parseInt(json['quantity'] ?? json['stock']),
      categoryId: parseInt(json['category_id']),
      sellerId: parseInt(json['seller_id']),
      seller: json['seller'] != null ? User.fromJson(json['seller']) : null,
      images: parseImages(json['images']) ??
          parseImages(json['image_url']) ??
          parseImages(json['image']) ??
          parseImages(json['thumbnail']) ??
          parseImages(json['cover']),
      status: json['status'] ?? (json['active'] == true ? 'active' : null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'seller_id': sellerId,
      'seller': seller?.toJson(),
      'images': images,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
