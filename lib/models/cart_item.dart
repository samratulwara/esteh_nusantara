import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size; // S, M, L
  String sweetness; // Normal, Less Sweet, Extra Sweet

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
    this.sweetness = 'Normal',
  });

  double get totalPrice {
    double sizeMultiplier = size == 'S' ? 1.0 : size == 'M' ? 1.3 : 1.6;
    return product.price * sizeMultiplier * quantity;
  }

  String get sizeLabel {
    switch (size) {
      case 'S': return 'Small (300ml)';
      case 'M': return 'Medium (500ml)';
      case 'L': return 'Large (700ml)';
      default: return size;
    }
  }
}
