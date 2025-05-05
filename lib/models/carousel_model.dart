class Carousel {
  final int? id;
  final String? imageUrl;
  final String? redirectUrl;
  final int? position;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  Carousel({
    this.id,
    this.imageUrl,
    this.redirectUrl,
    this.position,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      imageUrl: json['image_url'],
      redirectUrl: json['redirect_url'],
      position: json['position'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
