import 'package:bhukk1/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: GetMaterialApp(
        title: 'Bhukk App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages: AppRoutes.routes,
      ),
    );
  }
}
