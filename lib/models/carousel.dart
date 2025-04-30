class Carousel {
  final int id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? link;
  final bool isActive;

  Carousel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.link,
    required this.isActive,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      subtitle: json['subtitle'],
      link: json['link'],
      isActive: json['is_active'] ?? true,
    );
  }
}
