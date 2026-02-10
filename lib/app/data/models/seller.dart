class Seller {
  final int? id;
  final String? storeName;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? initials;
  final int? ordersCount;
  final String? phone;
  final String? address;
  final bool? active;
  final int? ownerId;
  final String? ownerName;
  final String? ownerEmail;

  Seller({
    this.id,
    this.storeName,
    this.logoUrl,
    this.coverImageUrl,
    this.initials,
    this.ordersCount,
    this.phone,
    this.address,
    this.active,
    this.ownerId,
    this.ownerName,
    this.ownerEmail,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Seller(
      id: parseInt(json['id']),
      storeName: json['store_name'] ?? json['name'],
      logoUrl: json['logo_url'] ?? json['logo'],
      coverImageUrl: json['cover_image_url'] ?? json['cover_image'],
      initials: json['initials'],
      ordersCount: parseInt(json['orders_count']),
      phone: json['phone'],
      address: json['address'],
      active: json['active'],
      ownerId: parseInt(json['user_id']),
      ownerName: (json['user'] is Map) ? json['user']['name'] : null,
      ownerEmail: (json['user'] is Map) ? json['user']['email'] : null,
    );
  }
}
