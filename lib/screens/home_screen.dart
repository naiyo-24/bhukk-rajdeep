import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ads_carousel.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/bhukkads_carousel.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/category_section.dart';
import '../route/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import '../services/api_url.dart';
import '../models/restaurant.dart';
import '../models/carousel.dart';
import '../controllers/carousel_controller.dart'; // Updated import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBar(
        showProfileAvatar: true,
        backgroundColor: Colors.white,
        elevation: 0,
        showDrawerToggle: false, // Removed the three-bar option
        onPressed: () => Get.toNamed(Routes.account),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.deepOrangeAccent),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => Get.toNamed(Routes.search),
                            child: AbsorbPointer(
                              child: TextField(
                                enabled: false,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search for restaurants, dishes...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: const Color(0xFFFF6B00).withOpacity(0.7),
                                    size: 24,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: const Color(0xFFFF6B00).withOpacity(0.1),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: const Color(0xFFFF6B00).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Rest of the content
                      HomeContent(),
                    ],
                  ),
                ),
              ],
            ),
            if (_showConfetti) const ConfettiOverlay(),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  bool _isInitialized = false;
  bool _isLoading = true;
  List<Restaurant> restaurants = [];
  List<Carousel> carousels = [];
  late BhukkCarouselController _carouselController; // Updated type

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
    _fetchRestaurants();
    // We don't need to call _fetchCarousels() anymore since we're using the controller
    _carouselController = Get.put(BhukkCarouselController()); // The controller handles API fetching
  }

  Future<void> _fetchRestaurants() async {
    try {
      final response = await _apiService.get(ApiUrl.restaurants);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // _fetchCarousels has been removed as we're now using the controller

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _precacheImages();
      _isInitialized = true;
    }
  }

  void _precacheImages() {
    if (!mounted) return;

    final imageUrls = [
      'assets/icons/north_indian.webp',
      'assets/icons/south_indian.jpg', 
      'assets/icons/chinese.webp',
      'assets/icons/italian.jpg',
      'assets/icons/food.png'
    ];

    for (String url in imageUrls) {
      precacheImage(AssetImage(url), context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  

  Widget _buildActionBox({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isLeftBox,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 115, // More compact height
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(32),
            bottomLeft: const Radius.circular(32),
            topLeft: Radius.circular(isLeftBox ? 8 : 32),
            bottomRight: Radius.circular(isLeftBox ? 32 : 8),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(32),
              bottomLeft: const Radius.circular(32),
              topLeft: Radius.circular(isLeftBox ? 8 : 32),
              bottomRight: Radius.circular(isLeftBox ? 32 : 8),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.85),
                    color,
                    color.withOpacity(0.95),
                  ],
                  stops: const [0.2, 0.5, 0.9],
                ),
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(32),
                  bottomLeft: const Radius.circular(32),
                  topLeft: Radius.circular(isLeftBox ? 8 : 32),
                  bottomRight: Radius.circular(isLeftBox ? 32 : 8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: -4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: isLeftBox ? -20 : null,
                    bottom: isLeftBox ? null : -20,
                    right: -20,
                    child: Icon(
                      icon,
                      size: 90, // Smaller background icon
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            size: 24, // Smaller icon
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18, // Smaller text
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.3,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(1),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _carouselController.isLoading.value
          ? const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            )
          : _carouselController.carousels.isEmpty
            ? const SizedBox(
                height: 240,
                child: Center(
                  child: Text(
                    'No offers available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : AdsCarousel(
                carousels: _carouselController.carousels,
                height: 240,
                viewportFraction: 0.92,
                onTap: (String? link) {
                  if (link != null) {
                    // Handle link navigation
                    print('Navigate to: $link');
                  }
                },
              ),
        ),

        // Using our new CategorySection widget
        const CategorySection(),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 1), // Reduced top padding to 0 and bottom to 12
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionBox(
                title: 'Book Table',
                icon: Icons.table_restaurant,
                color: const Color(0xFFFF6B00), // Main orange theme color
                onTap: () => Get.toNamed('/book-table'),
                isLeftBox: true,
              ),
              _buildActionBox(
                title: 'Order Liquor',
                icon: Icons.wine_bar,
                color: Color.fromARGB(255, 246, 100, 42), // Slightly different orange shade
                onTap: () => Get.toNamed('/order-liquor'),
                isLeftBox: false,
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Top Restaurants',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurants.length > 3 ? 3 : restaurants.length,  // Only show 3 items
                addAutomaticKeepAlives: false,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 150,
                            child: Image.network(
                              restaurant.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/cafes/restaurant.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            restaurant.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.green.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                restaurant.rating.toStringAsFixed(1),
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      restaurant.cuisineType,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            restaurant.address,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Open • ${restaurant.openingTime.substring(0, 5)}-${restaurant.closingTime.substring(0, 5)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 4),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Get.toNamed(
                                              Routes.restaurantTableBook,
                                              arguments: {
                                                'restaurantId': restaurant.id.toString(),
                                                'restaurantName': restaurant.name
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.table_restaurant, size: 16, color: Colors.white),
                                          label: const Text('Book'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF6B00),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

        // Add View All button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: TextButton(
            onPressed: () => Get.toNamed(Routes.booktable),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: const Color(0xFFFF6B00),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View All Restaurants',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: const Color.fromARGB(255, 254, 254, 254),
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'Work with us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const BhukkadsCarousel(),
        const SizedBox(height: 42),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and company section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bhukk',
                    style: TextStyle(
                      color: const Color(0xFFFF6B00),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'by Naiyo24',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Links section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerSectionTitle('Company'),
                        _footerLink('About Us'),
                        _footerLink('Blog'),
                        _footerLink('Careers'),
                        _footerLink('Contact'),
                      ],
                    ),
                  ),
                  // Second column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerSectionTitle('For Restaurants'),
                        _footerLink('Partner With Us'),
                        _footerLink('Apps For You'),
                        _footerLink('Business App'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Third column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerSectionTitle('Learn More'),
                        _footerLink('Privacy'),
                        _footerLink('Security'),
                        _footerLink('Terms'),
                        _footerLink('Sitemap'),
                      ],
                    ),
                  ),
                  // Fourth column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerSectionTitle('Social Links'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.instagram),
                              color: Colors.grey[700],
                              iconSize: 18,
                              constraints: BoxConstraints.tightFor(width: 36, height: 36),
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.twitter),
                              color: Colors.grey[700],
                              iconSize: 18,
                              constraints: BoxConstraints.tightFor(width: 36, height: 36),
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.facebook),
                              color: Colors.grey[700],
                              iconSize: 18,
                              constraints: BoxConstraints.tightFor(width: 36, height: 36),
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.linkedin),
                              color: Colors.grey[700],
                              iconSize: 18,
                              constraints: BoxConstraints.tightFor(width: 36, height: 36),
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Divider(color: Colors.grey[300], height: 1),
              const SizedBox(height: 20),
              
              // Footer
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Made with ♥ in India',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '🇮🇳',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© ${DateTime.now().year} Bhukk Ltd. All rights reserved.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _footerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}