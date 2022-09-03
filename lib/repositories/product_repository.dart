import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductRepository {
  final _baseUrl = 'https://shop-3677d-default-rtdb.firebaseio.com/products';

  Future<Map<String, dynamic>> loadProducts() async {
    Map<String, dynamic> data = {};

    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body != 'null') data = jsonDecode(response.body);

    return data;
  }

  Future<String> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    return jsonDecode(response.body)['name'];
  }

  Future<int> updateProduct(Product product) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/${product.id}.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );
    return response.statusCode;
  }

  Future<int> removeProduct(Product product) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/${product.id}.json'),
    );

    return response.statusCode;
  }
}
