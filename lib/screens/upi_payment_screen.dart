import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/success_popup.dart';

class UPIPaymentScreen extends StatefulWidget {
  const UPIPaymentScreen({Key? key}) : super(key: key);

  @override
  State<UPIPaymentScreen> createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Process UPI payment
      showSuccessPopup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'UPI Payment',
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
                controller: _upiController,
                decoration: const InputDecoration(
                  labelText: 'UPI ID',
                  hintText: 'username@upi',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter valid UPI ID' : null,
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
