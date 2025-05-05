import 'package:flutter/material.dart';

class Carousel {
  final int? id;
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? link; // Used for redirectUrl
  final int? position;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  Carousel({
    this.id,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.link,
    this.position,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    // Handle null or invalid index/position values
    int? parseIntSafely(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        // Remove any non-numeric characters and try to parse
        final cleanString = value.replaceAll(RegExp(r'[^0-9]'), '');
        return cleanString.isEmpty ? null : int.tryParse(cleanString);
      }
      return null;
    }

    String? parseImageUrl(dynamic value) {
      if (value == null) return null;
      final url = value.toString().trim();
      
      // Handle data URLs by returning null
      if (url.startsWith('data:image')) {
        return null;
      }
      
      // Handle empty URLs
      if (url.isEmpty) {
        return null;
      }
      
      // Handle relative URLs by adding base URL if needed
      if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('assets/')) {
        // If it's a local asset path without the 'assets/' prefix
        if (!url.contains('/')) {
          return 'assets/images/$url';
        }
      }
      
      return url;
    }

    return Carousel(
      id: parseIntSafely(json['id']),
      imageUrl: parseImageUrl(json['image_url']),
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      link: json['redirect_url']?.toString(),
      position: parseIntSafely(json['position']) ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Add a static method to check if images are loaded
  static bool isImagesLoaded = false;
  
  // Method to mark images as loaded
  static void markImagesLoaded() {
    isImagesLoaded = true;
  }
  
  // Method to check if images are loaded and preload them
  static Future<void> preloadImages(List<Carousel> carousels, BuildContext context) async {
    if (isImagesLoaded) return;
    
    try {
      for (var carousel in carousels) {
        if (carousel.imageUrl != null && carousel.imageUrl!.isNotEmpty) {
          final imageProvider = NetworkImage(carousel.imageUrl!);
          await precacheImage(imageProvider, context);
        }
      }
      markImagesLoaded();
    } catch (e) {
      print('Error preloading carousel images: $e');
      // Mark as loaded anyway to avoid getting stuck in loading state
      markImagesLoaded();
    }
  }

  // Add loading status for individual carousel images
  bool isImageLoaded = false;
  
  // Method to mark this carousel's image as loaded
  void markImageLoaded() {
    isImageLoaded = true;
  }
}
