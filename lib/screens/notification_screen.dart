import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../route/routes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
    bool isUnread = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: isUnread
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () => Get.toNamed(Routes.orderDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: 'Notifications',
        elevation: 0,
        onPressed: () => Get.back(),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all_rounded, color: Colors.deepOrange),
            onPressed: () {
              // Add clear all functionality
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 8),
          _buildNotificationItem(
            title: 'Special Offer!',
            message: '50% off on your first order. Order now!',
            time: '2 minutes ago',
            icon: Icons.local_offer_rounded,
            color: Colors.orange,
            isUnread: true,
          ),
          _buildNotificationItem(
            title: 'Order Confirmed',
            message: 'Your order #123456 has been confirmed',
            time: '1 hour ago',
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            isUnread: true,
          ),
          _buildNotificationItem(
            title: 'Table Reserved',
            message: 'Your table for 4 is confirmed at Restaurant ABC',
            time: '2 hours ago',
            icon: Icons.table_restaurant_rounded,
            color: Colors.blue,
          ),
          _buildNotificationItem(
            title: 'Payment Success',
            message: 'Payment of ₹499 received successfully',
            time: 'Yesterday',
            icon: Icons.payment_rounded,
            color: Colors.purple,
          ),
          _buildNotificationItem(
            title: 'New Restaurant',
            message: 'Check out the new restaurant in your area!',
            time: '2 days ago',
            icon: Icons.restaurant_rounded,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
