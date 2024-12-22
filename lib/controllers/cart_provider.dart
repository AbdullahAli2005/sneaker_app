import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  final Box _cartBox = Hive.box("cart_box");

  List<dynamic> _cart = [];

  List<dynamic> get cart => _cart;

  void getCart() {
    final cartData = _cartBox.keys.map((key) {
      final item = _cartBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "category": item['category'],
        "name": item['name'],
        "imageUrl": item['imageUrl'],
        "price": item['price'],
        "qty": item['qty'],
        "sizes":
            item["sizes"] is List ? item["sizes"].join(', ') : item["sizes"],
      };
    }).toList();

    _cart = cartData.reversed.toList();
    notifyListeners(); // Notify listeners after updating the cart
  }

  // Future<void> deleteItem(int key) async {
  //   await _cartBox.delete(key);
  //   getCart(); // Refresh the cart after deletion
  // }
  void deleteItem(int key) {
    _cartBox.delete(key);
    getCart(); // Refresh the cart list
    notifyListeners(); // Notify listeners after deletion
  }

  void incrementQuantity(String key) {
  final item = _cartBox.get(key);
  if (item != null) {
    item['qty']++;
    _cartBox.put(key, item); // Save updated quantity back to Hive
    getCart(); // Notify listeners to refresh UI
    notifyListeners();
  }
}

  void decrementQuantity(String key) {
  final item = _cartBox.get(key);
  if (item != null && item['qty'] > 1) {
    item['qty']--;
    _cartBox.put(key, item); // Save updated quantity back to Hive
    getCart(); // Notify listeners to refresh UI
    notifyListeners();
  }
}
}
