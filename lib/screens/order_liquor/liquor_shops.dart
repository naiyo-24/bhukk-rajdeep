import 'package:bhukk1/providers/cart_provider.dart';
import 'package:bhukk1/route/routes.dart';
import 'package:bhukk1/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class LiquorShopDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shop;

  const LiquorShopDetailScreen({super.key, required this.shop});

  @override
  State<LiquorShopDetailScreen> createState() => _LiquorShopDetailScreenState();
}

class _LiquorShopDetailScreenState extends State<LiquorShopDetailScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _scrollOffset = 0;
  String _selectedCategory = 'All';
  bool _isConnected = true;
  Map<String, int> _cartItems = {};
  late AnimationController _animationController;
  final List<String> _drinkImages = [
    'https://images.unsplash.com/photo-1514218698632-ef079aaafdb4',
    'https://images.unsplash.com/photo-1587223075055-82e5ca1db7bb',
    'https://images.unsplash.com/photo-1608885898957-a75e12cc00ea',
  ];

  final List<Map<String, dynamic>> _drinks = [
    {
      'id': '1', // Added ID
      'name': 'Chivas Regal 18',
      'description': 'Premium Blended Scotch Whisky',
      'price': '8999',
      'image': 'https://www.whiskyshop.com/media/catalog/product/c/h/chivas-18-year-old.jpg',
      'category': 'Whiskey',
    },
    {
      'id': '2', // Added ID
      'name': 'Grey Goose',
      'description': 'Premium French Vodka',
      'price': '5999',
      'image': 'https://www.greygoose.com/content/dam/greygoose/global/products/original/grey-goose-original-bottle.jpg',
      'category': 'Vodka',
    },
    {
      'id': '3', // Added ID
      'name': 'Dom Pérignon',
      'description': 'Vintage Champagne',
      'price': '29999',
      'image': 'https://www.domperignon.com/sites/default/files/2020-09/Dom-Perignon-Vintage-2010.jpg',
      'category': 'Wine',
    },
    {
      'id': '4', // Added ID
      'name': 'Macallan 12',
      'description': 'Single Malt Scotch Whisky',
      'price': '7999',
      'image': 'https://images.unsplash.com/photo-1527281400683-1aae777175f8?auto=format&fit=crop&w=500&q=80',
      'category': 'Whiskey',
    },
    {
      'id': '5', // Added ID
      'name': 'Hennessy XO',
      'description': 'Cognac',
      'price': '12999',
      'image': 'https://images.unsplash.com/photo-1547595425-4f1c58849767?auto=format&fit=crop&w=500&q=80',
      'category': 'Whiskey',
    },
    {
      'id': '6', // Added ID
      'name': 'Absolut Vodka',
      'description': 'Swedish Vodka',
      'price': '2999',
      'image': 'https://images.unsplash.com/photo-1608885896563-bb2f6193e5ec?auto=format&fit=crop&w=500&q=80',
      'category': 'Vodka',
    },
    {
      'id': '7', // Added ID
      'name': 'Glenlivet 15',
      'description': 'Single Malt Scotch Whisky',
      'price': '6999',
      'image': 'https://images.unsplash.com/photo-1621873495884-838fa89829e7?auto=format&fit=crop&w=500&q=80',
      'category': 'Whiskey',
    },
    {
      'id': '8', // Added ID
      'name': 'Moët & Chandon',
      'description': 'Imperial Brut Champagne',
      'price': '4999',
      'image': 'https://images.unsplash.com/photo-1594372365893-653de2a86fa2?auto=format&fit=crop&w=500&q=80',
      'category': 'Wine',
    },
    {
      'id': '9', // Added ID
      'name': 'Jack Daniel\'s',
      'description': 'Tennessee Whiskey',
      'price': '3999',
      'image': 'https://images.unsplash.com/photo-1591881915889-3853ed676265?auto=format&fit=crop&w=500&q=80',
      'category': 'Whiskey',
    },
    {
      'id': '10', // Added ID
      'name': 'Baileys',
      'description': 'Irish Cream Liqueur',
      'price': '2499',
      'image': 'https://images.unsplash.com/photo-1621873495884-838fa89829e7?auto=format&fit=crop&w=500&q=80',
      'category': 'Whiskey',
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _precacheImages();
  }

  void _precacheImages() async {
    for (String imageUrl in _drinkImages) {
      await precacheImage(
        CachedNetworkImageProvider(
          imageUrl,
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

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  List<Map<String, dynamic>> _getFilteredDrinks() {
    if (_selectedCategory == 'All') return _drinks;
    return _drinks.where((drink) => drink['category'] == _selectedCategory).toList();
  }

  Widget _buildCategoryPills() {
    final categories = ['All', 'Whiskey', 'Vodka', 'Gin', 'Wine', 'Beer'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == categories.length - 1 ? 16 : 8,
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

  Widget _buildDrinksList() {
    final filteredDrinks = _getFilteredDrinks();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: filteredDrinks.length,
      cacheExtent: 1000,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final drink = filteredDrinks[index];
        return _buildDrinkCard(drink);
      },
    );
  }

  Widget _buildDrinkCard(Map<String, dynamic> drink) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final quantity = _cartItems[drink['id']] ?? 0;

    void _showCartPopup() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Item Added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Your item has been added to the cart successfully!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'View Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {}, // Handle tap
          child: Row(
            children: [
              Hero(
                tag: 'drink-${drink['id']}',
                child: Container(
                  width: 130,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: drink['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        drink['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${drink['price']}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (quantity == 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _cartItems[drink['id']] = 1);
                                cartProvider.addToCart(
                                  drink['id'],
                                  1,
                                  name: drink['name'],
                                  price: drink['price'],
                                  image: drink['image'],
                                );
                                _showCartPopup(); // Show popup when adding to cart
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shadowColor: Colors.orange.withOpacity(0.4),
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.orange),
                                  onPressed: () {
                                    setState(() {
                                      if (_cartItems[drink['id']]! > 0) {
                                        _cartItems[drink['id']] = _cartItems[drink['id']]! - 1;
                                        cartProvider.updateQuantity(drink['id'], _cartItems[drink['id']]!);
                                      }
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.orange),
                                  onPressed: () {
                                    setState(() {
                                      _cartItems[drink['id']] = (_cartItems[drink['id']] ?? 0) + 1;
                                      cartProvider.updateQuantity(drink['id'], _cartItems[drink['id']]!);
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.shop['name'],
                    style: TextStyle(
                      color: _scrollOffset > 140 ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Hero(
                    tag: 'shop-${widget.shop['id']}',
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.darken,
                      child: CachedNetworkImage(
                        imageUrl: widget.shop['image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error_outline),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildCategoryPills(),
                    const SizedBox(height: 16),
                    _buildDrinksList(),
                  ],
                ),
              ),
            ],
          ),
          if (!_isConnected)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'No internet connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
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
