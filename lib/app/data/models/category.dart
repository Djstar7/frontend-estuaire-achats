class Category {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final int? parentId;
  final int? level;
  final bool? isActive;
  final List<Category>? children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.description,
    this.image,
    this.parentId,
    this.level,
    this.isActive,
    this.children,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    List<Category>? parseChildren(dynamic value) {
      if (value is List) {
        return value
            .map((child) => Category.fromJson(Map<String, dynamic>.from(child as Map)))
            .toList();
      }
      return null;
    }

    return Category(
      id: parseInt(json['id']),
      name: json['name'],
      description: json['description'],
      image: json['image'],
      parentId: parseInt(json['parent_id']),
      level: parseInt(json['level']),
      isActive: json['is_active'],
      children: parseChildren(json['children']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'parent_id': parentId,
      'level': level,
      'is_active': isActive,
      'children': children?.map((child) => child.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
