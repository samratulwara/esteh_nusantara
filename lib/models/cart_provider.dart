import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get subtotal => totalPrice;

  // Ongkir dihitung di checkout berdasarkan metode pengiriman
  // Gunakan getDeliveryFee(metode) di bawah
  double get deliveryFee => 5000; // default, di-override di checkout
  double get grandTotal => subtotal + deliveryFee;

  /// Hitung ongkir berdasarkan metode pengiriman
  double getDeliveryFee(String metodePengiriman) {
    if (metodePengiriman == 'Ambil Sendiri (Pick-up)') return 0;
    return totalPrice > 0 ? 5000 : 0;
  }

  /// Grand total berdasarkan metode pengiriman
  double getGrandTotal(String metodePengiriman) {
    return subtotal + getDeliveryFee(metodePengiriman);
  }

  void addItem(Product product, {String size = 'M', String sweetness = 'Normal'}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.size == size && item.sweetness == sweetness,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, size: size, sweetness: sweetness));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQty(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQty(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getItemCount(String productId) {
    return _items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}
