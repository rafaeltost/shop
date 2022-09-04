import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';
import 'package:shop/repositories/order_repository.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];
  OrderRepository ? orderRepository;

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  OrderList([String token = '', String userId = '',List<Order> items = const []]){
    _items = items;
    orderRepository = OrderRepository(token, userId);
  }

  Future<void> loadProducts() async {
    List<Order> items = [];
    List<Order> orders = await orderRepository!.loadProducts();
    if (orders.isEmpty) return;
    items.addAll(orders);
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    Order order = Order(
      id: '',
      total: cart.totalAmount,
      date: DateTime.now(),
      products: cart.items.values.toList(),
    );

    order.id = await orderRepository!.addOrder(order);

    _items.insert(0, order);
    notifyListeners();
  }
}
