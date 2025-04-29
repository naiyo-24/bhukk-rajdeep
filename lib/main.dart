import 'package:bhukk1/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'package:get/get.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
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
        theme: AppTheme.getThemeData(),
        initialRoute: '/splash',
        getPages: AppRoutes.routes,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}
