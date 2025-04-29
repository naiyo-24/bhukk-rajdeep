import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:ui';

class OrderLiquorScreen extends StatefulWidget {
  const OrderLiquorScreen({super.key});
  @override
  State<OrderLiquorScreen> createState() => _OrderLiquorScreenState();
}

class _OrderLiquorScreenState extends State<OrderLiquorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Explore our Collection',
        backgroundColor: Colors.white.withOpacity(1 - (_scrollOffset / 200).clamp(0, 0.5)),
        elevation: _scrollOffset > 0 ? 1 : 0,
        onPressed: () => Get.back(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Adjusted index to reflect the new order
        onTap: (index) {
          setState(() {
            _scrollOffset = 0; // Reset scroll offset if needed
          });
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = _scrollController.offset;
            });
          }
          return true;
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 100, bottom: 20),
            itemCount: _wineShops.length,
            cacheExtent: 100.0, // Improve scroll performance
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1), // Reduced slide distance
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          (index * 0.05).clamp(0, 1), // Faster animation sequence
                          ((index + 1) * 0.05).clamp(0, 1),
                          curve: Curves.easeOutCubic, // Smoother curve
                        ),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            (index * 0.05).clamp(0, 1),
                            ((index + 1) * 0.05).clamp(0, 1),
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: _buildWineShopCard(context, _wineShops[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWineShopCard(BuildContext context, Map<String, dynamic> shop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Handle tap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'shop-${shop['name']}',
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(shop['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            shop['speciality'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shop['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  shop['rating'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              shop['address'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            shop['timing'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/someRoute');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'View Collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _wineShops = [
    {
      'name': 'Royal Wine & Spirits',
      'address': '123 MG Road, Bangalore',
      'rating': 4.5,
      'timing': '10:00 AM - 11:00 PM',
      'image': 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=800&q=80',
      'speciality': 'Premium Imported Wines',
    },
    {
      'name': 'City Wine Shop',
      'address': '456 Brigade Road, Bangalore',
      'rating': 4.2,
      'timing': '11:00 AM - 10:00 PM',
      'image': 'https://images.unsplash.com/photo-1584432810601-6c7f27d2362b?auto=format&fit=crop&w=800&q=80',
      'speciality': 'Local & International Spirits',
    },
    {
      'name': 'Elite Spirits Hub',
      'address': '789 Indiranagar, Bangalore',
      'rating': 4.7,
      'timing': '10:00 AM - 10:30 PM',
      'image': 'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?auto=format&fit=crop&w=800&q=80',
      'speciality': 'Rare & Exclusive Collections',
    },
    {
      'name': 'Premium Wines & More',
      'address': '321 Koramangala, Bangalore',
      'rating': 4.6,
      'timing': '10:30 AM - 10:00 PM',
      'image': 'https://images.unsplash.com/photo-1510972527921-ce03766a1cf1?auto=format&fit=crop&w=800&q=80',
      'speciality': 'Premium Wine Collection',
    },
    {
      'name': 'The Wine Cellar',
      'address': '567 HSR Layout, Bangalore',
      'rating': 4.8,
      'timing': '11:00 AM - 11:00 PM',
      'image': 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=800&q=80',
      'speciality': 'Vintage Collections',
    },
  ];
}
