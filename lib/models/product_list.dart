import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/repositories/product_repository.dart';
import 'package:shop/services/favorite_product_service.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  ProductRepository? repository;
  String? _token;
  String? _userId;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  ProductList([String token = '', String userId = '', List<Product> items = const []]) {
    _items = items;
    _userId = userId;
    _token = token;
    repository = ProductRepository(token);
  }

  Future<void> loadProducts() async {
    _items.clear();

    Map<String, dynamic> data = await repository!.loadProducts();
    if (data.isEmpty) return;

    Map<String, dynamic> favoritesData =
        await FavoriteProductService().loadFavorites(_token!, _userId!);

    data.forEach((productId, productData) {
      final isFavorite = favoritesData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : '',
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final id = await repository!.addProduct(product);
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final responseStatusCode = await repository!.updateProduct(product);

      if (responseStatusCode >= 400) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final responseStatusCode = await repository!.removeProduct(product);

      if (responseStatusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: responseStatusCode,
        );
      }
    }
  }
}
