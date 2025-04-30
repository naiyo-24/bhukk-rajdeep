import 'package:bhukk1/models/restaurant.dart';
import 'package:bhukk1/screens/account_screen.dart';
import 'package:bhukk1/screens/book_restaurant/menu_card.dart';
import 'package:bhukk1/screens/book_restaurant/restaurant_table_book.dart';
import 'package:bhukk1/screens/book_table.dart';
import 'package:bhukk1/screens/cart_screen.dart';
import 'package:bhukk1/screens/category_items_screen.dart';
import 'package:bhukk1/screens/edit_profile_screen.dart';
import 'package:bhukk1/screens/home_screen.dart';
import 'package:bhukk1/screens/login_screen.dart';
import 'package:bhukk1/screens/notification_screen.dart';
import 'package:bhukk1/screens/order_history_screen.dart';
import 'package:bhukk1/screens/order_liquor/liquor_shops.dart';
import 'package:bhukk1/screens/order_liquor/order_liquor_screen.dart' as orderLiquor;
import 'package:bhukk1/screens/order_liquor_screen.dart';
import 'package:bhukk1/screens/payment_screen.dart';
import 'package:bhukk1/screens/settings_screen.dart';
import 'package:bhukk1/screens/signup_screen.dart';
import 'package:bhukk1/screens/splash_screen.dart';
import 'package:bhukk1/screens/track_order_screen.dart';
import 'package:bhukk1/screens/card_payment_screen.dart';
import 'package:bhukk1/screens/upi_payment_screen.dart';
import 'package:bhukk1/screens/privacy_policy_screen.dart';
import 'package:bhukk1/screens/terms_screen.dart';
import 'package:bhukk1/screens/search_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String splash = '/splash';
  static const String forgetpass = '/forgot-password';
  static const String home = '/home';
  static const String account = '/account';
  static const String cart = '/cart';
  static const String booktable = '/book-table';
  static const String restaurantDetails = '/restaurant-details';
  static const String orderLiquor = '/order-liquor';
  static const String payment = '/payment';
  static const String orderHistory = '/order-history';
  static const String categoryItems = '/category-items';
  static const String settings = '/settings';
  static const String liquorShops = '/liquor-shops';
  static const String trackOrder = '/track-order';
  static const String editProfile = '/edit-profile';
  static const String restaurantTableBook = '/restaurant-table-book';
  static const String menuCard = '/menu-card';
  static const String notifications = '/notifications';
  static const String checkout = '/checkout';
  static const String cardPayment = '/card-payment';
  static const String upiPayment = '/upi-payment';
  static const String orderDetails = '/order-details';
  static const String privacyPolicy = '/privacy-policy';
  static const String terms = '/terms';
  static const String search = '/search';
}

class AppRoutes {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.account,
      page: () => const AccountScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.booktable,
      page: () => const BookTableScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.orderLiquor,
      page: () {
        // Safely handle arguments that might be null
        final args = Get.arguments;
        final orderLiquor.LiquorOrder? order = args is orderLiquor.LiquorOrder ? args : null;
        return orderLiquor.OrderLiquorScreen(order: order);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.orderHistory,
      page: () => const OrderHistoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.categoryItems,
      page: () {
        final args = Get.arguments;
        String category = '';
        if (args is Map<String, dynamic> && args.containsKey('category')) {
          category = args['category']?.toString() ?? '';
        }
        return CategoryItemsScreen(category: category);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.liquorShops,
      page: () {
        final args = Get.arguments;
        dynamic shop;
        if (args is Map<String, dynamic> && args.containsKey('shop')) {
          shop = args['shop'];
        }
        return LiquorShopDetailScreen(shop: shop);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.trackOrder,
      page: () => const TrackOrderScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.restaurantTableBook,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final restaurant = args?['restaurant'] as Restaurant?;
        print('Creating RestaurantTableBook with restaurant: ${restaurant?.id}');
        return RestaurantTableBook(restaurant: restaurant);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.menuCard,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final restaurantName = args?['restaurantName'] as String? ?? '';
        final restaurantId = args?['restaurantId'] as String? ?? '';
        print('Creating MenuCard with ID: $restaurantId, Name: $restaurantName');
        return MenuCard(
          restaurantName: restaurantName,
          restaurantId: restaurantId,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cardPayment,
      page: () {
        final args = Get.arguments;
        String paymentMethod = 'Credit Card';
        if (args is String) {
          paymentMethod = args;
        }
        return CardPaymentScreen(paymentMethod: paymentMethod);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.upiPayment,
      page: () => const UPIPaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.terms,
      page: () => const TermsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}