import 'package:flutter/material.dart';
import 'package:shopa/models/category.dart';

class Categories extends StatelessWidget {
  final Function(String) onCategorySelected; // Kategori seçildiğinde callback

  const Categories({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onCategorySelected(
                  categories[index].title); // Kategori seçildiğinde
            },
            child: Column(
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(categories[index].image),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  categories[index].title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
