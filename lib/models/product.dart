class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String category;
  final bool isBestSeller;
  final String? imagePath; // path ke assets/images/nama_file.jpg

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.category,
    this.isBestSeller = false,
    this.imagePath,
  });
}
