import 'package:flutter/material.dart';
import 'package:shopa/Provider/cart_provider.dart';
import 'package:shopa/constants.dart';

import 'package:shopa/screens/cart/check_out.dart';
import 'package:shopa/screens/nav_bar_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final finalList = provider.cart;

    // arttırma azaltma
    productQuantity(IconData icon, int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (icon == Icons.add) {
              // Artırma işlemi
              provider.incrementQtn(
                  index); // Artırılacak miktar (1'er 1'er artacak)
            } else {
              // Azaltma işlemi
              provider.decrementQtn(index);
            }
          });
        },
        child: Icon(
          icon,
          size: 22,
        ),
      );
    }

    return Scaffold(
      bottomSheet: const CheckOutBox(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBar(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      "Sepetim",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: finalList.length,
                shrinkWrap:
                    true, // This makes the ListView take only the space it needs
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling inside the ListView
                itemBuilder: (context, index) {
                  final cartItems = finalList[index];
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: kcontentColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.network(cartItems.imageUrl),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    cartItems.category,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey.shade400),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "₺${cartItems.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 35,
                        right: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                finalList.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: kcontentColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  productQuantity(Icons.add, index),
                                  const SizedBox(width: 10),
                                  Text(
                                    cartItems.quantitiy.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  productQuantity(Icons.remove, index),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 400), // Add 100 height space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
