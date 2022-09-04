import 'dart:convert';

import 'package:http/http.dart' as http;

class FavoriteProductService {
  static const _baseUrl = 'https://shop-3677d-default-rtdb.firebaseio.com/userFavorites/';

  Future<int> toggleFavorite(String token, String userId, String productId, bool isFavorite) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$userId/$productId.json?auth=$token'),
      body: jsonEncode(isFavorite),
    );
    return response.statusCode;
  }

  Future<Map<String, dynamic>> loadFavorites( String token, String userId) async {
    Map<String, dynamic> data = {};

    final response = await http.get(Uri.parse('$_baseUrl/$userId.json?auth=$token'));

    if (response.body != 'null') data = jsonDecode(response.body);

    return data;
  }
}
