import 'package:bhukk1/models/restaurant_cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../route/routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isInitialized = false;
  String? selectedAddress;
  final List<String> addresses = [
    'Home: 123 Main St, City',
    'Work: 456 Office Rd, City',
    'Other: 789 Park Ave, City'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimations();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    setState(() {
      _isInitialized = true;
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildPriceRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(String id, String price, String imageUrl, int quantity) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Dismissible(
            key: Key(id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                final cart = Provider.of<CartProvider>(context, listen: false);
                cart.removeItem(id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item removed from cart'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Hero(
                      tag: 'drink-$id',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.liquor, size: 40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          id,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹$price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  final cart = Provider.of<CartProvider>(context, listen: false);
                                  cart.updateQuantity(id, quantity - 1);
                                },
                                iconSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  final cart = Provider.of<CartProvider>(context, listen: false);
                                  cart.updateQuantity(id, quantity + 1);
                                },
                                iconSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
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

  Widget _buildRestaurantBooking(RestaurantCartItem booking) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dismissible(
          key: Key(booking.restaurantName),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              final cart = Provider.of<CartProvider>(context, listen: false);
              cart.removeRestaurantBooking(booking); // Fixed: Passing the booking object instead of casting it
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${booking.restaurantName} removed from cart'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  booking.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                booking.restaurantName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Table ${booking.tableNumber} - ${booking.theme}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Text(
                '₹${booking.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillDetails(CartProvider cart) {
    final double subtotal = cart.totalAmount;
    final double discount = subtotal * 0.1; // 10% discount
    final double deliveryFee = 40.0;
    final double platformFee = 20.0;
    final double gst = subtotal * 0.05; // 5% GST
    final double total = subtotal - discount + deliveryFee + platformFee + gst;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPriceRow('Item Total', '₹${subtotal.toStringAsFixed(2)}'),
            _buildPriceRow('Coupon Discount', '-₹${discount.toStringAsFixed(2)}'),
            _buildPriceRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(2)}'),
            _buildPriceRow('Platform Fee', '₹${platformFee.toStringAsFixed(2)}'),
            _buildPriceRow('GST and Restaurant Charges', '₹${gst.toStringAsFixed(2)}'),
            const Divider(),
            _buildPriceRow('Total Amount', '₹${total.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDropdown() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedAddress,
              decoration: const InputDecoration(
                hintText: 'Select delivery address',
                border: OutlineInputBorder(),
              ),
              items: addresses.map((address) {
                return DropdownMenuItem(
                  value: address,
                  child: Text(address),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAddress = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cart',
        backgroundColor: Colors.white,
        elevation: 1,
        onPressed: () => Get.back(),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty && cart.restaurantBookings.isEmpty
                  ? const Center(
                      child: Text('Your cart is empty'),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (cart.restaurantBookings.isNotEmpty) ...[
                          const Text(
                            'Restaurant Bookings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...cart.restaurantBookings.map((booking) => _buildRestaurantBooking(booking)).toList(),
                          const SizedBox(height: 20),
                        ],
                        if (cartItems.isNotEmpty) ...[
                          const Text(
                            'Liquor Items', // Updated to include all liquor items, including wines
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: cartItems.entries.map((entry) {
                                return Column(
                                  children: [
                                    _buildCartItem(
                                      entry.value.name,
                                      entry.value.price,
                                      entry.value.image,
                                      entry.value.quantity,
                                    ),
                                    if (entry.key != cartItems.keys.last)
                                      const Divider(),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildAddressDropdown(),
                        const SizedBox(height: 20),
                        _buildBillDetails(cart),
                      ],
                    ),
            ),
            // Checkout Button
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedAddress == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a delivery address'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Get.toNamed(Routes.payment);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}