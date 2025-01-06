import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopa/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  List<Product> get cart => _cart;

  final ValueNotifier<List<Product>> cartNotifier = ValueNotifier([]);

  // Sepete ürün ekleme
  void addProductToCart(Product product, int quantity) {
    for (Product element in _cart) {
      if (element.imageUrl == product.imageUrl) {
        // Sepette zaten varsa ve stok sınırını geçmiyorsa
        if (element.quantitiy + quantity <= product.quantitiy) {
          element.quantitiy += quantity; // Miktarı artır
          notifyListeners();
          cartNotifier.value = List.from(_cart);
        } else {
          debugPrint(
              "Stok sınırına ulaşıldı111!"); // Eğer stok sınırına ulaşılırsa
        }
        return;
      }
    }

    // Eğer ürün sepette yoksa, yeni bir ürün ekle
    if (quantity <= product.quantitiy) {
      product.quantitiy = quantity;
      _cart.add(product);
      notifyListeners();
      cartNotifier.value = List.from(_cart);
    } else {
      debugPrint("Stok sınırını aşan miktar girilemez.");
    }
  }

  // Ürün miktarını artırma
  void incrementQtn(int index) {
    Product cartProduct = _cart[index];
    if (cartProduct.quantitiy <= cartProduct.quantitiy) {
      // Ürünün stok sınırına ulaşılmadıysa
      cartProduct.quantitiy++;
      notifyListeners();
      cartNotifier.value = List.from(_cart);
    } else {
      debugPrint(
          "Stok sınırına ulaşıldı!"); // Stok sınırına ulaşıldığında hata mesajı
    }
  }

  // Ürün miktarını azaltma
  void decrementQtn(int index) {
    if (_cart[index].quantitiy > 1) {
      _cart[index].quantitiy--;
      notifyListeners();
      cartNotifier.value = List.from(_cart);
    } else {
      debugPrint("Ürün miktarı 1'den az olamaz!");
    }
  }

  // Sepeti temizleme
  void clearCart() {
    _cart.clear();
    notifyListeners();
    cartNotifier.value = List.from(_cart);
  }

  // Toplam fiyat hesaplama
  double totalPrice() {
    double total = 0.0;
    for (Product element in _cart) {
      total += element.price * element.quantitiy;
    }
    return total;
  }

  // CartProvider erişimi
  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(context, listen: listen);
  }
}
