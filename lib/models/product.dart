import 'package:flutter/material.dart';
import 'package:shop/services/favorite_product_service.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(
      String token, String userId, String productId) async {
    _toggleFavorite();

    final responseStatusCode = await FavoriteProductService().toggleFavorite(token, userId, productId, isFavorite);

    if (responseStatusCode >= 400) {
      _toggleFavorite();
    }
  }
}
