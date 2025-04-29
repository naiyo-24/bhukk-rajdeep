import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/restaurant.dart';
import '../route/routes.dart';

class BookTableScreen extends StatefulWidget {
  final String? restaurantName;

  const BookTableScreen({
    super.key,
    this.restaurantName,
  });

  @override
  State<BookTableScreen> createState() => _BookTableScreenState();
}

class _BookTableScreenState extends State<BookTableScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: "La Luna Elegante",
      theme: "Moonlight Fine Dining",
      location: "Downtown Square",
      imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80",
      availableTables: 5,
      pricePerTable: 299.99,
      cuisine: "Fine Dining",
      rating: 4.8,
      priceRange: r"$$$",
      isOpen: true,
      menuCategories: ["Fine Dining", "Wine", "Gourmet"],
      operatingHours: {
        "monday": {"open": "18:00", "close": "23:00"},
        "tuesday": {"open": "18:00", "close": "23:00"},
        "wednesday": {"open": "18:00", "close": "23:00"},
        "thursday": {"open": "18:00", "close": "23:00"},
        "friday": {"open": "18:00", "close": "00:00"},
        "saturday": {"open": "18:00", "close": "00:00"},
        "sunday": {"open": "18:00", "close": "23:00"},
      },
    ),
    Restaurant(
      id: 'r2',
      name: "Candlelight Romance",
      theme: "Romantic Candlelight Dinner",
      location: "Marina Bay",
      imageUrl: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80",
      availableTables: 3,
      pricePerTable: 349.99,
      cuisine: "French",
      rating: 4.9,
      priceRange: r"$$$$",
      isOpen: true,
      menuCategories: ["French", "Wine", "Romantic"],
      operatingHours: {
        "monday": {"open": "17:00", "close": "23:00"},
        "tuesday": {"open": "17:00", "close": "23:00"},
        "wednesday": {"open": "17:00", "close": "23:00"},
        "thursday": {"open": "17:00", "close": "23:00"},
        "friday": {"open": "17:00", "close": "00:00"},
        "saturday": {"open": "17:00", "close": "00:00"},
        "sunday": {"open": "17:00", "close": "23:00"},
      },
    ),
    Restaurant(
      id: 'r3',
      name: "The Royal Feast",
      theme: "Royal Dining Experience",
      location: "Palace District",
      imageUrl: "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80",
      availableTables: 7,
      pricePerTable: 499.99,
      cuisine: "Royal",
      rating: 4.7,
      priceRange: r"$$$$",
      isOpen: true,
      menuCategories: ["Royal", "Gourmet", "Wine"],
      operatingHours: {
        "monday": {"open": "18:00", "close": "23:00"},
        "tuesday": {"open": "18:00", "close": "23:00"},
        "wednesday": {"open": "18:00", "close": "23:00"},
        "thursday": {"open": "18:00", "close": "23:00"},
        "friday": {"open": "18:00", "close": "00:00"},
        "saturday": {"open": "18:00", "close": "00:00"},
        "sunday": {"open": "18:00", "close": "23:00"},
      },
    ),
    Restaurant(
      id: 'r4',
      name: "Skyline Bistro",
      theme: "Rooftop Dining",
      location: "City Center",
      imageUrl: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?q=80",
      availableTables: 4,
      pricePerTable: 399.99,
      cuisine: "Bistro",
      rating: 4.6,
      priceRange: r"$$$",
      isOpen: true,
      menuCategories: ["Bistro", "Wine", "Rooftop"],
      operatingHours: {
        "monday": {"open": "18:00", "close": "23:00"},
        "tuesday": {"open": "18:00", "close": "23:00"},
        "wednesday": {"open": "18:00", "close": "23:00"},
        "thursday": {"open": "18:00", "close": "23:00"},
        "friday": {"open": "18:00", "close": "00:00"},
        "saturday": {"open": "18:00", "close": "00:00"},
        "sunday": {"open": "18:00", "close": "23:00"},
      },
    ),
    Restaurant(
      id: 'r5',
      name: "Garden Paradise",
      theme: "Garden Restaurant",
      location: "Botanical Gardens",
      imageUrl: "https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?q=80",
      availableTables: 6,
      pricePerTable: 249.99,
      cuisine: "Garden",
      rating: 4.5,
      priceRange: r"$$",
      isOpen: true,
      menuCategories: ["Garden", "Vegetarian", "Organic"],
      operatingHours: {
        "monday": {"open": "18:00", "close": "23:00"},
        "tuesday": {"open": "18:00", "close": "23:00"},
        "wednesday": {"open": "18:00", "close": "23:00"},
        "thursday": {"open": "18:00", "close": "23:00"},
        "friday": {"open": "18:00", "close": "00:00"},
        "saturday": {"open": "18:00", "close": "00:00"},
        "sunday": {"open": "18:00", "close": "23:00"},
      },
    ),
    Restaurant(
      id: 'r6',
      name: "Oriental Pearl",
      theme: "Asian Fusion",
      location: "East Side",
      imageUrl: "https://images.unsplash.com/photo-1526069631228-723c945bea6b?q=80",
      availableTables: 8,
      pricePerTable: 279.99,
      cuisine: "Asian",
      rating: 4.7,
      priceRange: r"$$$",
      isOpen: true,
      menuCategories: ["Asian", "Fusion", "Gourmet"],
      operatingHours: {
        "monday": {"open": "18:00", "close": "23:00"},
        "tuesday": {"open": "18:00", "close": "23:00"},
        "wednesday": {"open": "18:00", "close": "23:00"},
        "thursday": {"open": "18:00", "close": "23:00"},
        "friday": {"open": "18:00", "close": "00:00"},
        "saturday": {"open": "18:00", "close": "00:00"},
        "sunday": {"open": "18:00", "close": "23:00"},
      },
    ),
  ];

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
        title: 'Book a Table',
        backgroundColor: Colors.white.withOpacity(1 - (_scrollOffset / 200).clamp(0, 0.5)),
        elevation: _scrollOffset > 0 ? 1 : 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.offNamed(Routes.home),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          setState(() {
            _scrollOffset = 0;
            _scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
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
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 100, bottom: 20),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        (index * 0.1).clamp(0, 1),
                        ((index + 1) * 0.1).clamp(0, 1),
                        curve: Curves.easeOutQuart,
                      ),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          (index * 0.1).clamp(0, 1),
                          ((index + 1) * 0.1).clamp(0, 1),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    child: _buildRestaurantCard(context, restaurants[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'restaurant-${restaurant.name}',
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(restaurant.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
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
                                restaurant.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                restaurant.theme,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.cuisine,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  restaurant.rating.toString(),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Text(
                            restaurant.location,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.restaurantTableBook);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Explore Now'),
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
}
