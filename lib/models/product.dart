class Product {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String seller;
  final String category;
  int quantitiy;

  Product(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.seller,
      required this.category,
      required this.quantitiy});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'seller': seller,
      'category': category,
      'quantitiy': quantitiy
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      seller: map['seller'] ?? '',
      category: map['category'] ?? '',
      quantitiy: map['quantitiy'] ?? 0,
    );
  }
}
