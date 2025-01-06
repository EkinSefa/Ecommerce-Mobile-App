import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shopa/models/product.dart';
import 'package:shopa/screens/Home/Widget/category.dart';
import 'package:shopa/screens/Home/Widget/home_app_bar.dart';
import 'package:shopa/screens/Home/Widget/image_slider.dart';
import 'package:shopa/screens/Home/Widget/product_cart.dart';
import 'package:shopa/screens/Home/Widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<Product> allProducts = [];
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "Hepsi";

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = prefs.getStringList('products') ?? [];

    try {
      final loadedProducts = productList
          .where((productJson) {
            try {
              json.decode(productJson);
              return true;
            } catch (_) {
              return false;
            }
          })
          .map((productJson) => Product.fromMap(json.decode(productJson)))
          .toList();

      setState(() {
        products = loadedProducts;
        allProducts = loadedProducts;
        filteredProducts = loadedProducts;
      });
    } catch (e) {
      debugPrint('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  void filterProducts(String query, String category) {
    setState(() {
      selectedCategory = category;

      List<Product> tempProducts = allProducts;

      // Kategoriye göre filtreleme
      if (category != "Hepsi") {
        tempProducts = tempProducts
            .where((product) => product.category == category)
            .toList();
      }

      // Arama metnine göre filtreleme
      if (query.isNotEmpty) {
        tempProducts = tempProducts
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      filteredProducts = tempProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const CustomAppBar(),
              const SizedBox(height: 10),
              MySearchBar(
                searchController: searchController,
                onSearch: (query) {
                  filterProducts(query, selectedCategory);
                },
              ),
              const SizedBox(height: 20),
              ImageSlider(
                currentSlide: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Categories(
                onCategorySelected: (category) {
                  filterProducts(searchController.text, category);
                },
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Size Özel",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "Hepsini gör",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                ],
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCart(product: product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
