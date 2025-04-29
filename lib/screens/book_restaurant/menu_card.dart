import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../route/routes.dart';

class MenuCard extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;

  const MenuCard({
    Key? key, 
    required this.restaurantName,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Classic Burger',
      'description': 'Juicy beef patty with fresh veggies',
      'price': '199',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80',
      'category': 'Main Course'
    },
    {
      'name': 'Margherita Pizza',
      'description': 'Fresh tomatoes, mozzarella, and basil',
      'price': '299',
      'image': 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?q=80',
      'category': 'Main Course'
    },
    {
      'name': 'Caesar Salad',
      'description': 'Crisp romaine lettuce with Caesar dressing',
      'price': '149',
      'image': 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?q=80',
      'category': 'Starters'
    },
  ];

  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Main Course', 'Starters', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          '${widget.restaurantName} Menu',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: selectedCategory == categories[index],
                    label: Text(categories[index]),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: selectedCategory == categories[index]
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuItems.where((item) =>
                selectedCategory == 'All' ||
                item['category'] == selectedCategory
              ).length,
              itemBuilder: (context, index) {
                final filteredItems = menuItems.where((item) =>
                  selectedCategory == 'All' ||
                  item['category'] == selectedCategory
                ).toList();
                final item = filteredItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: item['image'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.restaurant_menu, size: 40),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['description'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${item['price']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          final cartProvider = Provider.of<CartProvider>(
                                            context,
                                            listen: false,
                                          );
                                          cartProvider.addItem(
                                            item['name'],
                                            item['price'],
                                            item['image'],
                                            1  // Adding initial quantity of 1
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${item['name']} added to cart'),
                                              action: SnackBarAction(
                                                label: 'View Cart',
                                                onPressed: () {
                                                  Get.toNamed(Routes.cart);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Add to Cart'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}