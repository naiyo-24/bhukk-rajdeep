import 'package:bhukk1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../route/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
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

  void _sendOtp() {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() {
      _isOtpSent = true;
    });
    _startOtpTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    Get.offAllNamed(Routes.home);
  }

  @override
  void dispose() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
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
                child: TextField(
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
                ),
              ),
              if (_isOtpSent) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextField(
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
                onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
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
                  _isOtpSent ? 'Login' : 'Send OTP',
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
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.signup),
                      child: Text(
                        'Sign Up',
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
    );
  }
}