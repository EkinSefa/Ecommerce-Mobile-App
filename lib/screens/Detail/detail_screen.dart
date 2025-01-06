import 'package:flutter/material.dart';
import 'package:shopa/models/product.dart';
import 'package:shopa/screens/Home/Widget/addto_cart.dart';
import 'package:shopa/screens/nav_bar_screen.dart'; // Ana sayfa için kullanılan widget'ı import et

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue, // Geri butonunun rengini mavi yapıyoruz
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const BottomNavBar()), // Ana sayfaya dön
            );
          },
        ),
        title: Text(product.title),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Image.network(
                product.imageUrl,
                height: 500,
                width: 40,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${product.price} ₺',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 20, // 10 birim daha aşağıya
            left: 0,
            right: 0,
            child: AddToCart(product: product),
          ),
          // Kırmızı geri butonu sağ üst köşede
        ],
      ),
    );
  }
}
