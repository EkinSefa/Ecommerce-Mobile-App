import 'package:flutter/material.dart';
import 'package:shopa/models/product.dart';

class MyImageSlider extends StatelessWidget {
  final Product product;
  final Function(int) onChange;
  const MyImageSlider(
      {super.key, required this.product, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemBuilder: (context, item) {
          return Hero(
            tag: product.imageUrl,
            child: Image.network(
              product.imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
