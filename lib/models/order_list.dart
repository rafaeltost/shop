import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';
import 'package:shop/repositories/order_repository.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    List<Order> orders = await OrderRepository().loadProducts();
    if (orders.isEmpty) return;
    _items.addAll(orders);
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    Order order = Order(
      id: '',
      total: cart.totalAmount,
      date: DateTime.now(),
      products: cart.items.values.toList(),
    );

    order.id = await OrderRepository().addOrder(order);

    _items.insert(0, order);
    notifyListeners();
  }
}
