import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/routes.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade400,
        title: const Text('My Orders', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOrderStatusCard('Active', '2', true),
                _buildOrderStatusCard('Completed', '8', false),
                _buildOrderStatusCard('Cancelled', '1', false),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_bag, color: Colors.orange.shade400),
                      ),
                      title: Text(
                        'Order #${1000 + index}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Ordered on ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Delivered',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.trackOrder),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildOrderItem('Burger', '2x', '24.99'),
                                _buildOrderItem('Fries', '1x', '4.99'),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '\$29.98',
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Get.toNamed(Routes.cart),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Reorder'),
                                ),
                              ],
                            ),
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

  Widget _buildOrderStatusCard(String title, String count, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: isActive ? Colors.orange.shade400 : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.orange.shade400 : Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(quantity,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text('\$$price',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
