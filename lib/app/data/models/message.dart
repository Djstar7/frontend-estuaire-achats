import 'package:frontend_estuaire_achats/app/data/models/user.dart';

class Message {
  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? content;
  final bool? isRead;
  final User? sender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Message({
    this.id,
    this.conversationId,
    this.senderId,
    this.content,
    this.isRead,
    this.sender,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      isRead: json['is_read'],
      sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'is_read': isRead,
      'sender': sender?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}