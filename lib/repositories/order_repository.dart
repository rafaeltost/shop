import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';

class OrderRepository {
  final _baseUrl = 'https://shop-3677d-default-rtdb.firebaseio.com/orders';

  Future<String> addOrder(Order order) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode(
        {
          "total": order.total,
          "date": order.date.toIso8601String(),
          "products": order.products
              .map(
                (item) => {
                  "id": item.id,
                  "productId": item.productId,
                  "name": item.name,
                  "quantity": item.quantity,
                  "price": item.price
                },
              )
              .toList()
        },
      ),
    );

    return jsonDecode(response.body)['name'];
  }

  Future<List<Order>> loadProducts() async {
    List<Order> orders = [];

    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body != 'null') {
      Map<String, dynamic> data = jsonDecode(response.body);
      
      data.forEach((orderId, orderData) {
        orders.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price'],
              );
            }).toList(),
          ),
        );
      });
    }
    return orders;
  }
}
