import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ads_carousel.dart';
import 'delivery_partner_contact_screen.dart';
import '../route/routes.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> adImages = [
      'assets/images/ad1.jpg',
      'assets/images/ad2.jpg',
      'assets/images/ad3.jpg',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Track Order',
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () => Get.back(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const DeliveryPartnerContactScreen(),
          );
        },
        backgroundColor: Colors.orange.shade400,
        child: const Icon(
          Icons.delivery_dining,
          size: 28,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://www.google.com/maps/place/1%2F21B,+New+South+Park,+Baghajatin+Colony,+Kolkata,+West+Bengal+700086/@22.4860476,88.3755201,17z/data=!3m1!4b1!4m6!3m5!1s0x3a027113f0ff3405:0x3e4ed22a1084e1c5!8m2!3d22.4860476!4d88.378095!16s%2Fg%2F11f3_77876?entry=ttu&g_ep=EgoyMDI1MDQxNi4xIKXMDSoASAFQAw%3D%3D',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: Colors.orange.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #123456',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _buildTrackingStep(
                      'Order Confirmed',
                      'Your order has been placed',
                      true,
                      isFirst: true,
                    ),
                    _buildTrackingStep(
                      'Preparing',
                      'Your order is being prepared',
                      false,
                    ),
                    _buildTrackingStep(
                      'On the Way',
                      'Our delivery partner is picking up your order',
                      false,
                    ),
                    _buildTrackingStep(
                      'Delivered',
                      'Thank you for ordering with us',
                      false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AdsCarousel(
              adImages: adImages,
              height: 230,
              viewportFraction: 0.85,
              onTap: () => Get.toNamed(Routes.orderDetails),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(
    String title,
    String subtitle,
    bool isCompleted, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: VerticalDivider(
                      color: isCompleted ? Colors.orange.shade400 : Colors.grey[300],
                      thickness: 2,
                    ),
                  ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.orange.shade400 : Colors.grey[300],
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: VerticalDivider(
                      color: Colors.grey[300],
                      thickness: 2,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
