import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String cuisine;
  final double rating;
  final String priceRange;
  final bool isOpen;
  final List<String> menuCategories;
  final Map<String, dynamic> operatingHours;
  final String theme;
  final double pricePerTable;
  final int availableTables;
  
  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.cuisine,
    required this.rating,
    required this.priceRange,
    required this.isOpen,
    required this.menuCategories,
    required this.operatingHours,
    required this.theme,
    required this.pricePerTable,
    required this.availableTables,
  });

  // Factory constructor to create a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      location: json['location'] as String,
      cuisine: json['cuisine'] as String,
      rating: (json['rating'] as num).toDouble(),
      priceRange: json['priceRange'] as String,
      isOpen: json['isOpen'] as bool,
      menuCategories: List<String>.from(json['menuCategories'] as List),
      operatingHours: json['operatingHours'] as Map<String, dynamic>,
      theme: json['theme'] as String,
      pricePerTable: (json['pricePerTable'] as num).toDouble(),
      availableTables: json['availableTables'] as int,
    );
  }

  // Convert Restaurant instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'cuisine': cuisine,
      'rating': rating,
      'priceRange': priceRange,
      'isOpen': isOpen,
      'menuCategories': menuCategories,
      'operatingHours': operatingHours,
      'theme': theme,
      'pricePerTable': pricePerTable,
      'availableTables': availableTables,
    };
  }

  // Helper method to precache restaurant image
  Future<void> precacheImage(BuildContext context, BuildContext secondaryContext) async {
    await precacheImage(
      CachedNetworkImageProvider(
        imageUrl,
        maxWidth: 800, // For hero images
        maxHeight: 600,
      ) as BuildContext,
      context,
    );
  }

  // Create a cached network image widget with optimized settings
  Widget buildCachedImage({
    required BoxFit fit,
    double? width,
    double? height,
    Widget Function(BuildContext, String)? placeholderBuilder,
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      maxWidthDiskCache: 800,
      maxHeightDiskCache: 600,
      memCacheWidth: width?.toInt() ?? 400,
      memCacheHeight: height?.toInt() ?? 300,
      placeholder: placeholderBuilder ?? (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: errorBuilder ?? (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.error_outline),
      ),
    );
  }

  // Create a hero widget with cached image
  Widget buildHeroImage({
    required String heroTag,
    required BoxFit fit,
    double? width,
    double? height,
    Widget Function(BuildContext, String)? placeholderBuilder,
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
  }) {
    return Hero(
      tag: heroTag,
      child: buildCachedImage(
        fit: fit,
        width: width,
        height: height,
        placeholderBuilder: placeholderBuilder,
        errorBuilder: errorBuilder,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
