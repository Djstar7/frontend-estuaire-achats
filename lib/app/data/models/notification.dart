class Notification {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final String? type;
  final Map<String, dynamic>? data;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notification({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.type,
    this.data,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      isRead: json['is_read'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}