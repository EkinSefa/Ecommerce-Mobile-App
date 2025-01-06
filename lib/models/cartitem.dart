import 'package:shopa/models/product.dart';

class CartItem {
  final Product product;
  int quantitiy;

  CartItem({required this.product, required this.quantitiy});
}
