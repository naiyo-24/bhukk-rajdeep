import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class OrderLiquorScreen extends StatelessWidget {
  final dynamic order;

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

    // Parse order data safely to handle different formats
    String name = 'Liquor Order';
    String id = '0';
    String imageUrl = '';
    String description = 'Description not available';

    if (order is Map<String, dynamic>) {
      name = order['name']?.toString() ?? 'Liquor Order';
      id = order['id']?.toString() ?? '0';
      imageUrl = order['image_url'] ?? order['imageUrl'] ?? order['image'] ?? '';
      description = order['description']?.toString() ?? 'Description not available';
    } else if (order is LiquorOrder) {
      name = order.name;
      id = order.id;
      imageUrl = order.imageUrl;
      description = order.description;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 260,
              width: double.infinity,
              child: Hero(
                tag: 'liquor-$id',
                child: imageUrl.isNotEmpty 
                  ? _buildLiquorImage(imageUrl)
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.liquor, size: 80, color: Colors.grey)),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
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