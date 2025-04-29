import 'package:flutter/foundation.dart';
import '../models/restaurant_cart_item.dart';

class CartItem {
  final String name;
  final String price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final List<RestaurantCartItem> _restaurantBookings = [];

  Map<String, CartItem> get items => {..._items};
  List<RestaurantCartItem> get restaurantBookings => [..._restaurantBookings];

  bool get isEmpty => _items.isEmpty && _restaurantBookings.isEmpty;
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    double total = 0;
    _items.forEach((key, item) {
      total += double.parse(item.price) * item.quantity;
    });
    _restaurantBookings.forEach((booking) {
      total += booking.price;
    });
    return total;
  }

  void addItem(String name, String price, String image, int quantity) {
    if (_items.containsKey(name)) {
      _items.update(
        name,
        (existingItem) => CartItem(
          name: existingItem.name,
          price: existingItem.price,
          image: existingItem.image,
          quantity: quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        name,
        () => CartItem(
          name: name,
          price: price,
          image: image,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void addToCart(String id, int quantity, {String? name, String? price, String? image}) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) => CartItem(
          name: existingItem.name,
          price: existingItem.price,
          image: existingItem.image,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else if (name != null && price != null && image != null) {
      _items.putIfAbsent(
        id,
        () => CartItem(
          name: name,
          price: price,
          image: image,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String name) {
    _items.remove(name);
    notifyListeners();
  }

  void updateQuantity(String name, int quantity) {
    if (_items.containsKey(name)) {
      if (quantity <= 0) {
        _items.remove(name);
      } else {
        _items.update(
          name,
          (existingItem) => CartItem(
            name: existingItem.name,
            price: existingItem.price,
            image: existingItem.image,
            quantity: quantity,
          ),
        );
      }
      notifyListeners();
    }
  }

  void addRestaurantBooking(RestaurantCartItem booking) {
    _restaurantBookings.add(booking);
    notifyListeners();
  }

  void removeRestaurantBooking(RestaurantCartItem booking) {
    _restaurantBookings.remove(booking);
    notifyListeners();
  }
}
