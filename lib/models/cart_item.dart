import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;
  String sweetness;
  double? overridePrice; // harga khusus untuk dimsum porsi (1/3/7 pcs)

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
    this.sweetness = 'Normal',
    this.overridePrice,
  });

  double get unitPrice => overridePrice ?? product.price;

  double get totalPrice => unitPrice * quantity;

  String get sizeLabel => size;
}