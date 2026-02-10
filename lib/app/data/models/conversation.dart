import 'package:frontend_estuaire_achats/app/data/models/user.dart';

class Conversation {
  final int? id;
  final int? buyerId;
  final int? sellerId;
  final User? buyer;
  final User? seller;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Conversation({
    this.id,
    this.buyerId,
    this.sellerId,
    this.buyer,
    this.seller,
    this.lastMessage,
    this.lastMessageAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      buyerId: json['buyer_id'],
      sellerId: json['seller_id'],
      buyer: json['buyer'] != null ? User.fromJson(json['buyer']) : null,
      seller: json['seller'] != null ? User.fromJson(json['seller']) : null,
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null ? DateTime.parse(json['last_message_at']) : null,
      isActive: json['is_active'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'buyer': buyer?.toJson(),
      'seller': seller?.toJson(),
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}