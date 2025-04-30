import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../route/routes.dart';
import '../../services/api_service.dart';
import '../../services/api_url.dart';

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
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> menuItems = [];
  bool _isLoading = true;
  
  String selectedCategory = 'All';
  final List<String> categories = ['All'];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchRestaurantMenu();
  }

  Future<void> _fetchRestaurantMenu() async {
    if (!mounted) return;
    
    try {
      if (widget.restaurantId.isEmpty) {
        setState(() {
          _isLoading = false;
          menuItems = [];
        });
        return;
      }

      final String endpoint = ApiUrl.restaurantMenu.replaceAll(
        'id', 
        widget.restaurantId
      );
      
      final response = await _apiService.get(endpoint);
      
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          menuItems = List<Map<String, dynamic>>.from(response.data);
          final uniqueCategories = menuItems
              .map((item) => item['category'] as String)
              .toSet()
              .toList();
          
          categories
            ..clear()
            ..add('All')
            ..addAll(uniqueCategories);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          menuItems = [];
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load menu')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        menuItems = [];
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load menu')),
      );
    }
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: item['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                height: 200,
                child: const Icon(Icons.restaurant_menu, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        item['description'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${item['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(item['name'], item['price'], item['image'], 1);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${item['name']} added to cart'),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () => Get.toNamed(Routes.cart),
                      ),
                    ));
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: menuItems
                        .where((item) =>
                            selectedCategory == 'All' ||
                            item['category'] == selectedCategory)
                        .length,
                    itemBuilder: (context, index) {
                      final filteredItems = menuItems
                          .where((item) =>
                              selectedCategory == 'All' ||
                              item['category'] == selectedCategory)
                          .toList();
                      return _buildMenuItem(filteredItems[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}