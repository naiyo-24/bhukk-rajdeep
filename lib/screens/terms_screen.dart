import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Terms & Conditions',
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
              'Terms & Conditions',
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
              'Acceptance of Terms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'By accessing and using the Bhukk application, you accept and agree to be bound by the terms and provision of this agreement.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Use License',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Permission is granted to temporarily download one copy of the application for personal, non-commercial transitory viewing only.\n\n'
              'This is the grant of a license, not a transfer of title, and under this license you may not:\n\n'
              '• Modify or copy the materials\n'
              '• Use the materials for any commercial purpose\n'
              '• Attempt to decompile or reverse engineer any software contained in the application\n'
              '• Remove any copyright or other proprietary notations from the materials',
              style: TextStyle(fontSize: 16),
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}