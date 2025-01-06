import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopa/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorite = [];
  List<Product> get favorites => _favorite;

  FavoriteProvider() {
    _loadFavorites(); // Uygulama başladığında favorileri yükle
  }

  // SharedPreferences'ten favori ürünleri yükleme
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteJsonList = prefs.getStringList('favorites');
    if (favoriteJsonList != null) {
      _favorite = favoriteJsonList
          .map((json) => Product.fromMap(jsonDecode(json)))
          .toList();
      notifyListeners();
    }
  }

  // Favori ekleme veya çıkarma işlemi
  void toggleFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();

    // Ürün zaten favorilerdeyse, eklemeyi engelle
    if (_favorite.any((item) => item.imageUrl == product.imageUrl)) {
      return; // Ürün zaten favorilerde, hiçbir şey yapma
    }

    // Eğer ürün favorilerde değilse, ekle
    _favorite.add(product);

    // Favori ürünleri SharedPreferences'a kaydet
    List<String> favoriteJsonList =
        _favorite.map((product) => jsonEncode(product.toMap())).toList();
    await prefs.setStringList('favorites', favoriteJsonList);

    notifyListeners();
  }

  // Ürün favorilere eklenmiş mi kontrol etme
  bool isExist(Product product) {
    return _favorite.any((item) => item.imageUrl == product.imageUrl);
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
