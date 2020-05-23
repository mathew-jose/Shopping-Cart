import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String prod;
  final int quantity;
  final double price;

  Cart(this.id, this.prod, this.quantity, this.price);
}

class CartAdd with ChangeNotifier {
  Map<String, Cart> items = {};
  Map<String, Cart> get item {
    return {...items};
  }
  String auth;
  CartAdd(this.auth,this.items);

  int get cartsize {
    return items == null ? 0 : items.length;
  }

  double get totalcost {
    double total = 0.0;
    items.forEach((key, item) {
      total += (item.quantity * item.price);
    });
    return total;
  }

  void addItem(String id, String prod, double price) {
    if (items.containsKey(id)) {
      items.update(
        id,
        (exist) => Cart(exist.id, exist.prod, exist.quantity + 1, exist.price),
      );
    } else
      items.putIfAbsent(
        id,
        () => Cart(id, prod, 1, price),
      );
    notifyListeners();
  }

  void deleteItem(String id) {
    if (!items.containsKey(id)) {
      return;
    }
    if (items.containsKey(id))
     {
      if (items[id].quantity > 1)
        items.update(
          id,
          (exist) =>
              Cart(exist.id, exist.prod, exist.quantity - 1, exist.price),
        );
      else {
        items.remove(id);
      }
    }
    
    notifyListeners();
  }

  void removeItem(String id) {
    items.remove(id);
    notifyListeners();
  }

  void clear() {
    items = {};
    notifyListeners();
  }
}
