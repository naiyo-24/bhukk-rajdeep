import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../route/routes.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Payment',
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.orange.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Method',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred payment option',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                PaymentOptionTile(
                  icon: Icons.credit_card,
                  title: 'Credit Card',
                  subtitle: 'Pay using credit card',
                  onTap: () {
                    Get.toNamed(Routes.cardPayment, arguments: 'Credit Card');
                  },
                ),
                PaymentOptionTile(
                  icon: Icons.credit_card,
                  title: 'Debit Card',
                  subtitle: 'Pay using debit card',
                  onTap: () {
                    Get.toNamed(Routes.cardPayment, arguments: 'Debit Card');
                  },
                ),
                PaymentOptionTile(
                  icon: Icons.mobile_friendly,
                  title: 'UPI',
                  subtitle: 'Pay using UPI apps',
                  onTap: () {
                    Get.toNamed(Routes.upiPayment);
                  },
                ),
                PaymentOptionTile(
                  icon: Icons.account_balance,
                  title: 'Net Banking',
                  subtitle: 'Pay directly from your bank account',
                  onTap: () {
                    Get.toNamed(Routes.cardPayment, arguments: 'Net Banking');
                  },
                ),
                PaymentOptionTile(
                  icon: Icons.money,
                  title: 'Cash on Delivery',
                  subtitle: 'Pay when you receive your order',
                  onTap: () {
                    _showCODConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCODConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Confirm Order',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        content: const Text(
          'Do you want to place order with Cash on Delivery?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Payment processing logic here
                Get.offNamed(Routes.trackOrder);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Pay on Delivery'),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PaymentOptionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shadowColor: Colors.orange.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: Colors.orange.shade800),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
