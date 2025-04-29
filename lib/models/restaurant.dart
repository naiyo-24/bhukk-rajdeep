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
      id: json['id'],
      name: json['name'],
      theme: json['theme'],
      location: json['location'],
      imageUrl: json['image_url'],
      availableTables: json['available_tables'],
      pricePerTable: json['price_per_table'].toDouble(),
      cuisine: json['cuisine'],
      rating: json['rating'].toDouble(),
      priceRange: json['price_range'],
      isOpen: json['is_open'],
      menuCategories: List<String>.from(json['menu_categories']),
      operatingHours: Map<String, Map<String, String>>.from(json['operating_hours']),
    );
  }

  /// Creates a dummy restaurant with placeholder data when actual data is unavailable
  /// This helps show a proper UI instead of an error screen
  /// 
  /// @param id Optional ID for the dummy restaurant
  /// @return Restaurant instance with placeholder data
  static Restaurant dummy({String id = 'dummy-restaurant'}) {
    return Restaurant(
      id: id,
      name: 'Sample Restaurant',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80',
      location: 'City Center, Downtown',
      cuisine: 'Multi-Cuisine',
      rating: 4.5,
      priceRange: '₹₹₹',
      isOpen: true,
      menuCategories: [
        'Starters', 'Main Course', 'Desserts', 'Beverages'
      ],
      operatingHours: {
        'Monday': '11:00 AM - 11:00 PM',
        'Tuesday': '11:00 AM - 11:00 PM',
        'Wednesday': '11:00 AM - 11:00 PM',
        'Thursday': '11:00 AM - 11:00 PM',
        'Friday': '11:00 AM - 12:00 AM',
        'Saturday': '11:00 AM - 12:00 AM',
        'Sunday': '11:00 AM - 11:00 PM',
      },
      theme: 'Contemporary',
      pricePerTable: 999.0,
      availableTables: 8,
    );
  }

  /// Creates a list of dummy restaurants for use in lists when real data is unavailable
  /// 
  /// @param count Number of dummy restaurants to create
  /// @return List of Restaurant instances with placeholder data
  static List<Restaurant> dummyList(int count) {
    List<Restaurant> dummies = [];
    List<String> cuisines = [
      'North Indian', 'Chinese', 'Italian', 'Continental', 'South Indian', 'Thai'
    ];
    List<String> names = [
      'Gourmet Kitchen', 'Spice Garden', 'Fusion Bistro', 'Royal Dining', 
      'Coastal Flavors', 'Urban Café', 'Elegant Eatery', 'Foodie Paradise'
    ];
    List<String> images = [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80',
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80',
      'https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?q=80',
      'https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80',
      'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80',
    ];
    
    for (int i = 0; i < count; i++) {
      dummies.add(Restaurant(
        id: 'dummy-restaurant-${i+1}',
        name: names[i % names.length],
        imageUrl: images[i % images.length],
        location: 'Location ${i+1}',
        cuisine: cuisines[i % cuisines.length],
        rating: 3.5 + (i % 3) * 0.5,
        priceRange: List.filled((i % 3) + 1, '₹').join(''),
        isOpen: i % 3 != 0,
        menuCategories: [
          'Starters', 'Main Course', 'Desserts', 'Beverages'
        ],
        operatingHours: {
          'Monday': '11:00 AM - 11:00 PM',
          'Tuesday': '11:00 AM - 11:00 PM',
          'Wednesday': '11:00 AM - 11:00 PM',
          'Thursday': '11:00 AM - 11:00 PM',
          'Friday': '11:00 AM - 12:00 AM',
          'Saturday': '11:00 AM - 12:00 AM',
          'Sunday': '11:00 AM - 11:00 PM',
        },
        theme: i % 2 == 0 ? 'Contemporary' : 'Traditional',
        pricePerTable: 699.0 + (i * 100),
        availableTables: 5 + (i % 6),
      ));
    }
    return dummies;
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
