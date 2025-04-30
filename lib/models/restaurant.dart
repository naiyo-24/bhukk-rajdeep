import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Restaurant {
  final int id;
  final String name;
  final String description;
  final String address;
  final String cuisineType;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final int ownerId;
  final double rating;
  final bool isActive;
  final bool isApproved;
  final String imageUrl;
  final List<dynamic> tables;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.cuisineType,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    required this.ownerId,
    required this.rating,
    required this.isActive,
    required this.isApproved,
    required this.imageUrl,
    required this.tables,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      cuisineType: json['cuisine_type'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isActive: json['is_active'] ?? false,
      isApproved: json['is_approved'] ?? false,
      imageUrl: json['image_url'] ?? '',
      tables: json['tables'] ?? [],
    );
  }
}
