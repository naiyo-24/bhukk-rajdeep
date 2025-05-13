// filepath: /Users/rohitghosh/Documents/Projects/bhukk-rajdeep/lib/models/category.dart
class Category {
  final int id;
  final String name;
  final String imageUrl;
  final String? description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
