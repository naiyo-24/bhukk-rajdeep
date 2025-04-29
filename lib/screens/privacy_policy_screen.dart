import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: April 30, 2025',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bhukk respects your privacy and is committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our application and tell you about your privacy rights and how the law protects you.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We collect several different types of information for various purposes to provide and improve our service to you:\n\n'
              '• Personal Data: Name, email address, phone number\n'
              '• Usage Data: IP address, browser type, pages visited\n'
              '• Location Data: Geographic location for delivery services',
              style: TextStyle(fontSize: 16),
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}