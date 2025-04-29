import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class OrderLiquorScreen extends StatelessWidget {
  final LiquorOrder? order;

  const OrderLiquorScreen({Key? key, required this.order}) : super(key: key);

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildLiquorImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 800,
      memCacheHeight: 600,
      placeholder: (context, url) => _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.error_outline, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Liquor')),
        body: const Center(
          child: Text(
            'Error: Liquor order data not found.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(order!.name),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Hero(
              tag: 'liquor-${order!.id}',
              child: _buildLiquorImage(order!.imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              order!.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class LiquorOrder {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  LiquorOrder({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}