import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/routes.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index != currentIndex) {
      String route = '';
      switch (index) {
        case 0:
          route = Routes.home;
          break;
        case 1:
          route = Routes.orderLiquor;
          break;
        case 2:
          route = Routes.booktable;
          break;
        case 3:
          route = Routes.account;
          break;
        default:
          return;
      }
      
      Get.offNamed(route);
      onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _handleNavigation(context, index),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wine_bar_rounded),
            label: 'Order Liquor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant_rounded),
            label: 'Book Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'My Account',
          ),
        ],
      ),
    );
  }
}