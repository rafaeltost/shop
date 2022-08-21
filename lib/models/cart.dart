import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> items = {};

  Map<String, CartItem> get allItems => {...items};

  void addItem(Product product) {
    items.update(
      product.id,
      (item) => CartItem(
        id: item.id,
        productId: item.productId,
        name: item.name,
        quantity: item.quantity + 1,
        price: item.price,
      ),
      ifAbsent: () => CartItem(
        id: Random().nextDouble().toString(),
        productId: product.id,
        name: product.name,
        quantity: 1,
        price: product.price,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    items.remove(productId);
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void clear() {
    items = {};
    notifyListeners();
  }

  int get itemsCount => items.length;
}
