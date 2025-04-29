import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/success_popup.dart';
import '../route/routes.dart';

class CardPaymentScreen extends StatefulWidget {
  final String paymentMethod;

  const CardPaymentScreen({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String? _otp;

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      _showOTPDialog();
    }
  }

  void _showOTPDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter OTP'),
        content: TextField(
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) => _otp = value,
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit OTP',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Verify OTP and process payment
              Get.offNamed(Routes.trackOrder);
              Get.snackbar(
                'Success',
                'Payment processed successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.paymentMethod,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cardController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) =>
                    value?.length != 16 ? 'Enter valid card number' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) =>
                          value?.length != 3 ? 'Enter valid CVV' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
