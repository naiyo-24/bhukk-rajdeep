import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhukk1/route/routes.dart';
import 'package:bhukk1/widgets/bottom_nav_bar.dart';
import 'package:bhukk1/widgets/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bhukk1/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class LiquorItem {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final List<String> tags;
  final bool isFeatured;
  final String type;
  final String brand;
  final double? abv; // Alcohol By Volume

  LiquorItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.tags,
    this.isFeatured = false,
    required this.type,
    required this.brand,
    this.abv,
  });
}

class LiquorShowcaseScreen extends StatefulWidget {
  const LiquorShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<LiquorShowcaseScreen> createState() => _LiquorShowcaseScreenState();
}

class _LiquorShowcaseScreenState extends State<LiquorShowcaseScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  double _scrollOffset = 0;
  String _selectedCategory = 'All';
  final int _currentIndex = 1; // Liquor tab index
  final Map<String, int> _cartItems = {};

  // Filter options
  final List<String> _filters = ['All', 'Whiskey', 'Vodka', 'Rum', 'Gin', 'Beer', 'Wine'];

  // Demo liquor data
  final List<LiquorItem> _liquorItems = [
    LiquorItem(
      id: '1',
      name: 'Johnnie Walker Blue Label',
      imageUrl: 'https://images.unsplash.com/photo-1609292894075-57736a004a25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Premium Blended Scotch Whisky',
      price: 18999,
      tags: ['Premium', 'Scotch', 'Gift'],
      isFeatured: true,
      type: 'Whiskey',
      brand: 'Johnnie Walker',
      abv: 40.0,
    ),
    LiquorItem(
      id: '2',
      name: 'Grey Goose',
      imageUrl: 'https://images.unsplash.com/photo-1613613814051-7b3ee326c050?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Premium French Vodka',
      price: 5999,
      tags: ['Premium', 'French'],
      isFeatured: true,
      type: 'Vodka',
      brand: 'Grey Goose',
      abv: 40.0,
    ),
    LiquorItem(
      id: '3',
      name: 'Dom Pérignon Vintage',
      imageUrl: 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Vintage Champagne',
      price: 29999,
      tags: ['Luxury', 'Champagne', 'Vintage'],
      isFeatured: true,
      type: 'Wine',
      brand: 'Dom Pérignon',
      abv: 12.5,
    ),
    LiquorItem(
      id: '4',
      name: 'Macallan 18 Years',
      imageUrl: 'https://images.unsplash.com/photo-1582819509237-d5b75f20ff7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Single Malt Scotch Whisky, Aged 18 Years',
      price: 25999,
      tags: ['Single Malt', 'Aged', 'Premium'],
      isFeatured: false,
      type: 'Whiskey',
      brand: 'Macallan',
      abv: 43.0,
    ),
    LiquorItem(
      id: '5',
      name: 'Hennessy XO',
      imageUrl: 'https://images.unsplash.com/photo-1647461257109-b8127bbf46bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Cognac Extra Old',
      price: 14999,
      tags: ['Cognac', 'Extra Old', 'Premium'],
      isFeatured: true,
      type: 'Cognac',
      brand: 'Hennessy',
      abv: 40.0,
    ),
    LiquorItem(
      id: '6',
      name: 'Bombay Sapphire',
      imageUrl: 'https://images.unsplash.com/photo-1642771929677-ccc47145a661?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Premium London Dry Gin',
      price: 3499,
      tags: ['Gin', 'London Dry'],
      isFeatured: false,
      type: 'Gin',
      brand: 'Bombay Sapphire',
      abv: 47.0,
    ),
    LiquorItem(
      id: '7',
      name: 'Jack Daniel\'s Old No. 7',
      imageUrl: 'https://images.unsplash.com/photo-1609953927253-d0129de7ccdc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Tennessee Whiskey',
      price: 2999,
      tags: ['Tennessee', 'Classic'],
      isFeatured: false,
      type: 'Whiskey',
      brand: 'Jack Daniel\'s',
      abv: 40.0,
    ),
    LiquorItem(
      id: '8',
      name: 'Bacardi Carta Blanca',
      imageUrl: 'https://images.unsplash.com/photo-1644495747935-490b4193fc63?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'White Rum',
      price: 1899,
      tags: ['White Rum', 'Cocktail'],
      isFeatured: false,
      type: 'Rum',
      brand: 'Bacardi',
      abv: 37.5,
    ),
    LiquorItem(
      id: '9',
      name: 'Corona Extra',
      imageUrl: 'https://images.unsplash.com/photo-1607644536940-e92a72e61a0c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Mexican Lager Beer',
      price: 199,
      tags: ['Beer', 'Lager', 'Mexican'],
      isFeatured: false,
      type: 'Beer',
      brand: 'Corona',
      abv: 4.5,
    ),
    LiquorItem(
      id: '10',
      name: 'Moet & Chandon',
      imageUrl: 'https://images.unsplash.com/photo-1569777047543-ff8922517daa?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80',
      description: 'Imperial Brut Champagne',
      price: 4299,
      tags: ['Champagne', 'Brut'],
      isFeatured: true,
      type: 'Wine',
      brand: 'Moet & Chandon',
      abv: 12.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  void _precacheImages() async {
    for (var item in _liquorItems) {
      precacheImage(
        CachedNetworkImageProvider(
          item.imageUrl,
          maxWidth: 600,
          maxHeight: 400,
        ),
        context,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  List<LiquorItem> _getFilteredLiquorItems() {
    if (_selectedCategory == 'All') return _liquorItems;
    return _liquorItems.where((item) => item.type == _selectedCategory).toList();
  }

  List<LiquorItem> _getFeaturedLiquorItems() {
    return _liquorItems.where((item) => item.isFeatured).toList();
  }

  void _addToCart(LiquorItem item) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      _cartItems[item.id] = (_cartItems[item.id] ?? 0) + 1;
      cartProvider.addToCart(
        item.id,
        1,
        name: item.name,
        price: item.price.toString(),
        image: item.imageUrl,
      );
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Get.toNamed(Routes.cart),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Build category filter pills
  Widget _buildCategoryPills() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final category = _filters[index];
          final isSelected = _selectedCategory == category;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == _filters.length - 1 ? 16 : 8,
            ),
            child: Material(
              elevation: isSelected ? 8 : 2,
              shadowColor: isSelected ? Colors.orange.withOpacity(0.4) : Colors.black12,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedCategory = category);
                  _animationController.forward(from: 0);
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Colors.orange.shade300,
                              Colors.orange.shade400,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Featured section with horizontal scroll
  Widget _buildFeaturedSection() {
    final featuredItems = _getFeaturedLiquorItems();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Featured & Trending',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: featuredItems.length,
            itemBuilder: (context, index) {
              final item = featuredItems[index];
              return _buildFeaturedCard(item);
            },
          ),
        ),
      ],
    );
  }

  // Featured card with glassmorphism effect
  Widget _buildFeaturedCard(LiquorItem item) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Stack(
        children: [
          // Main card with image and glassmorphic overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          // Glassmorphism info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _addToCart(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'ORDER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Featured badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.deepOrange.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main grid of liquor cards
  Widget _buildLiquorItemsGrid() {
    final filteredItems = _getFilteredLiquorItems();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return _buildLiquorCard(item);
        },
      ),
    );
  }

  // Individual liquor card
  Widget _buildLiquorCard(LiquorItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.error_outline, size: 30),
                    ),
                  ),
                ),
                // Type pill
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => _addToCart(item),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
                            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Premium Liquor',
        backgroundColor: Colors.white.withOpacity(_scrollOffset > 20 ? 1 : 0),
        elevation: _scrollOffset > 20 ? 1 : 0,
        onPressed: () => Get.back(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.search),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {},
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
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header image
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://images.unsplash.com/photo-1516147790962-074604a32f01?auto=format&fit=crop&w=1200&h=600&q=80'
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Premium Collection',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Discover the finest spirits from around the world',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  _buildCategoryPills(),
                  _buildFeaturedSection(),
                  
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'All Bottles',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  _buildLiquorItemsGrid(),
                  
                  // Add some bottom padding
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => Get.toNamed(Routes.cart),
            backgroundColor: Colors.orange,
            label: Text(
              'View Cart (${cart.totalItems})',
              style: const TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          );
        },
      ),
    );
  }
}
