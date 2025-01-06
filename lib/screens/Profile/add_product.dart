import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shopa/models/product.dart';
import 'package:shopa/models/category.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantitiyController = TextEditingController();

  String selectedCategory = categories.first.title;

  Future<void> saveProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final product = Product(
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        seller: "Satıcı",
        category: selectedCategory,
        quantitiy: int.tryParse(_quantitiyController.text) ?? 0);

    final productList = prefs.getStringList('products') ?? [];
    productList.add(json.encode(product.toMap())); // Her zaman JSON'a çevir
    await prefs.setStringList('products', productList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün başarıyla kaydedildi!')),
    );

    // Temizle ve geri dön
    _titleController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    _quantitiyController.clear();
    setState(() {
      selectedCategory = categories.first.title;
    });

    Navigator.pop(context, true); // Ana sayfaya dönüşte güncelleme
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Ekleme'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Ürün Başlığı'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Resim URL'),
            ),
            TextField(
              controller: _quantitiyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Miktar'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Fiyat'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: categories
                  .map((category) => DropdownMenuItem<String>(
                        value: category.title,
                        child: Text(category.title),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Kategori Seçin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProduct,
              child: const Text('Ürünü Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
