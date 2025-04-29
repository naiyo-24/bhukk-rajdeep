import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nav_bar.dart';
import '../route/routes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _currentIndex = 3; // Profile tab

  Widget _buildOptionTile({
    required String title,
    required IconData icon,
    required String message,
    VoidCallback? onTap, // Added onTap callback
  }) {
    return ListTile(
      onTap: onTap ?? 
          () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Overlay patterns
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Section
                Row(
                  children: [
                    const SizedBox(width: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Debasish Ray',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '+91 9876543210',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Options Section
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildOptionTile(
                          title: 'Update Profile',
                          icon: Icons.edit,
                          message: 'Navigate to update your profile details.',
                          onTap: () => Get.toNamed('/editProfile'),
                        ),
                        _buildOptionTile(
                          title: 'My Orders',
                          icon: Icons.receipt_long,
                          message: 'Check your order history.',
                          onTap: () => Get.toNamed('/orderHistory'),
                        ),
                        _buildOptionTile(
                          title: 'Addresses',
                          icon: Icons.location_on,
                          message: 'Manage your saved addresses.',
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Saved Addresses',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    const ListTile(
                                      leading: Icon(Icons.home, color: Colors.orange),
                                      title: Text('123 Main Street, City'),
                                    ),
                                    const ListTile(
                                      leading: Icon(Icons.work, color: Colors.orange),
                                      title: Text('456 Office Road, City'),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('Add New Address'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildOptionTile(
                          title: 'Payment Methods',
                          icon: Icons.payment,
                          message: 'View and update your payment methods.',
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Saved Payment Methods',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    const ListTile(
                                      leading: Icon(Icons.credit_card, color: Colors.orange),
                                      title: Text('**** **** **** 1234'),
                                      subtitle: Text('Expires 12/24'),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('Add New Card'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildOptionTile(
                          title: 'Help & Support',
                          icon: Icons.help,
                          message: 'Get help and support for your account.',
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Help & Support',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Coming Soon',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildOptionTile(
                          title: 'About Us',
                          icon: Icons.info,
                          message: 'Learn more about our application.',
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'About Bhukk',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Bhukk is your go-to app for discovering restaurants, ordering food, and more!',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildOptionTile(
                          title: 'Settings',
                          icon: Icons.settings,
                          message: 'Adjust your account settings.',
                          onTap: () => Get.toNamed('/settings'),
                        ),
                        _buildOptionTile(
                          title: 'Notifications',
                          icon: Icons.notifications,
                          message: 'View your notifications.',
                          onTap: () => Get.toNamed('/notifications'),
                        ),
                        _buildOptionTile(
                          title: 'Logout',
                          icon: Icons.logout,
                          message: 'Log out of your account.',
                          onTap: () {
                            Get.offNamed('/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Adjusted index to reflect the new order
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}