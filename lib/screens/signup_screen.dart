import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../route/routes.dart';
import 'dart:async';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  Timer? _otpTimer;
  int _resendTime = 30;

  @override
  void initState() {
    super.initState();
  }

  void _startOtpTimer() {
    _resendTime = 30;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendTime > 0) {
          _resendTime--;
        } else {
          _otpTimer?.cancel();
        }
      });
    });
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _sendOtp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isOtpSent = true;
    });
    _startOtpTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify OTP first')),
      );
      return;
    }
    if (_otpController.text != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    Get.offAllNamed(Routes.home);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _otpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    textCapitalization: TextCapitalization.words,
                    enabled: !_isOtpSent,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isOtpSent,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_validateEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+91 ',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: !_isOtpSent,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                ),
                if (_isOtpSent) ...[
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 2),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_resendTime > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Resend OTP in $_resendTime seconds',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _sendOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isOtpSent ? _signup : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _isOtpSent ? 'Create Account' : 'Send OTP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!_isOtpSent) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.offNamed(Routes.login),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}