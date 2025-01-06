import 'package:flutter/material.dart';
import 'package:shopa/constants.dart';
import 'package:shopa/models/product.dart';
import 'package:shopa/screens/Detail/detail_screen.dart';
import 'package:shopa/screens/Favorite/favorite.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  const ProductCart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(
                    product: product,
                  )),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: kcontentColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Hero(
                    tag: product.imageUrl,
                    child: Image.network(
                      product.imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "₺${product.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                  color: kprimaryColorr,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                  )),
              child: GestureDetector(
                onTap: () {
                  provider.toggleFavorite(product);
                },
                child: Icon(
                  provider.isExist(product)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
