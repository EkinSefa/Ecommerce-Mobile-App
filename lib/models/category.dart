class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categories = [
  Category(
    title: "Hepsi",
    image: "images/all.png",
  ),
  Category(
    title: "Ayakkabı",
    image: "images/shoes.png",
  ),
  Category(
    title: "Bakım",
    image: "images/beauty.png",
  ),
  Category(
    title: "Kadın",
    image: "images/image1.png",
  ),
  Category(
    title: "Mücevher",
    image: "images/jewelry.png",
  ),
  Category(
    title: "Erkek",
    image: "images/men.png",
  ),
];
