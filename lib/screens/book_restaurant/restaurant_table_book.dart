import 'package:bhukk1/services/api_service.dart';
import 'package:bhukk1/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/cart_provider.dart';
import '../../models/restaurant_cart_item.dart' as cart_item;
import '../../models/restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../route/routes.dart';

class RestaurantTableBook extends StatefulWidget {
  final Restaurant? restaurant;

  const RestaurantTableBook({super.key, this.restaurant});

  @override
  _RestaurantTableBookState createState() => _RestaurantTableBookState();
}

class _RestaurantTableBookState extends State<RestaurantTableBook> with SingleTickerProviderStateMixin {
  Restaurant? restaurant;
  String selectedTheme = 'Moonlight Dinner';
  int selectedTable = -1;
  bool _imagesPrecached = false;

  final List<String> diningThemes = [
    'Moonlight Dinner',
    'Candlelight Dinner',
    'Prom Night', 
    'Regular Dining'
  ];

  final List<String> tableImages = [
    'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?q=80',
    'https://images.unsplash.com/photo-1523287562758-66c7fc58967f?q=80',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80',
    'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80',
  ];

  late ScrollController _scrollController;
  late AnimationController _animationController;
  double _headerImageOpacity = 1.0;

  final ApiService _apiService = ApiService();
  Restaurant? restaurantDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    restaurant = widget.restaurant;
    _isLoading = restaurant == null;
  }

  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      _precacheImages();
      _imagesPrecached = true;
      if (restaurant != null) {
        _fetchRestaurantDetails();
      }
    }
  }

  Future<void> _fetchRestaurantDetails() async {
    if (!mounted) return;

    try {
      if (restaurant?.id == null) {
        print('Restaurant ID is null');
        setState(() => _isLoading = false);
        return;
      }

      final String endpoint = ApiUrl.restaurantDetails.replaceAll(
        'id', 
        restaurant!.id.toString()
      );
      print('Fetching restaurant details from: $endpoint');
      
      final response = await _apiService.get(endpoint);
      print('Restaurant details response: ${response.data}');
      
      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = response.data is List 
            ? response.data.first 
            : response.data;
            
        setState(() {
          restaurantDetails = Restaurant.fromJson(responseData);
          _isLoading = false;
        });
        
        print('Successfully fetched details for restaurant: ${restaurantDetails?.name}');
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      print('Restaurant ID: ${restaurant?.id}');
      print('Restaurant name: ${restaurant?.name}');
      
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _precacheImages() async {
    if (restaurant != null) {
      // Precache restaurant image with size optimization
      await precacheImage(
        CachedNetworkImageProvider(
          restaurant!.imageUrl,
          maxWidth: 1200,
          maxHeight: 800,
        ),
        context,
      );
    }
    
    // Precache table images with size optimization
    for (String url in tableImages) {
      await precacheImage(
        CachedNetworkImageProvider(
          url,
          maxWidth: 800,
          maxHeight: 600,
        ),
        context,
      );
    }
  }

  void _onScroll() {
    if (!mounted) return;
    final offset = _scrollController.offset;
    setState(() {
      _headerImageOpacity = (1 - (offset / 200)).clamp(0.4, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (selectedTable != -1 && restaurant != null) {
      final booking = cart_item.RestaurantCartItem(
        restaurantName: restaurant!.name,
        imageUrl: restaurant!.imageUrl,
        tableNumber: selectedTable + 1,
        theme: selectedTheme,
        price: 999.0,
      );

      Provider.of<CartProvider>(context, listen: false).addRestaurantBooking(booking);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Table ${selectedTable + 1} added to cart',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(Routes.cart),
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _goToMenu() {
    if (restaurant?.id == null) return;
    
    print('Navigating to menu with ID: ${restaurant?.id}, Name: ${restaurant?.name}');
    Get.toNamed(
      Routes.menuCard,
      arguments: {
        'restaurantName': restaurant?.name ?? '',
        'restaurantId': restaurant?.id.toString() ?? '',
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildTableImage(String imageUrl) {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'restaurant-${restaurant?.id}',
                        child: CachedNetworkImage(
                          imageUrl: restaurant?.imageUrl ?? '',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant?.name ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                restaurant?.cuisineType ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${restaurant?.rating ?? 0.0}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Experience',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 55,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: diningThemes.length,
                            itemBuilder: (context, index) {
                              final theme = diningThemes[index];
                              final isSelected = selectedTheme == theme;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ChoiceChip(
                                  label: Text(theme),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedTheme = theme;
                                    });
                                  },
                                  selectedColor: Theme.of(context).primaryColor,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final isSelected = selectedTable == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTable = isSelected ? -1 : index;
                            });
                            if (!isSelected) {
                              _animationController.forward(from: 0);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildTableImage(tableImages[index % tableImages.length]),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Table ${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Text(
                                          '4 Seats',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Theme.of(context).primaryColor,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: 4,
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: ElevatedButton.icon(
              onPressed: _goToMenu,
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text(
                'View Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton.icon(
              onPressed: selectedTable != -1 ? _addToCart : null,
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
