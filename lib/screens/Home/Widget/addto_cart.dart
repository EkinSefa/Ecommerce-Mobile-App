import 'package:flutter/material.dart';
import 'package:shopa/Provider/cart_provider.dart';
import 'package:shopa/models/product.dart';

class AddToCart extends StatefulWidget {
  final Product product;
  const AddToCart({super.key, required this.product});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int currentQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Miktar Seçme Bölümü
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentQuantity > 1) {
                        setState(() {
                          currentQuantity--;
                        });
                      }
                    },
                    iconSize: 18,
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentQuantity.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      if (currentQuantity < widget.product.quantitiy) {
                        setState(() {
                          currentQuantity++;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Stok sınırını aşamazsınız!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    iconSize: 18,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Sepete Ekle Butonu
            GestureDetector(
              onTap: () {
                final cartProduct = provider.cart.firstWhere(
                  (element) => element.imageUrl == widget.product.imageUrl,
                  orElse: () => Product(
                    title: '',
                    price: 0,
                    imageUrl: '',
                    quantitiy: 0,
                    description: '',
                    seller: '',
                    category: '',
                  ),
                );

                int totalQuantityInCart =
                    cartProduct.imageUrl.isEmpty ? 0 : cartProduct.quantitiy;

                if (currentQuantity + totalQuantityInCart <=
                    widget.product.quantitiy) {
                  provider.addProductToCart(
                    widget.product,
                    currentQuantity,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Sepete $currentQuantity adet eklendi",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Ürün İle ilgili işlemlere Sepetten Devam Ediniz!!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: const Text(
                  "Sepete Ekle",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
