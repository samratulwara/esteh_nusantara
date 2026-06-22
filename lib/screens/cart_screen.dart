import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.softGreenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text('Keranjang Saya 🛒',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearDialog(context, cart),
              child: Text('Hapus Semua',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
            ),
        ],
      ),
      body: cart.items.isEmpty ? _buildEmptyCart(context) : _buildCartList(context, cart),
      bottomNavigationBar: cart.items.isEmpty ? null : _buildCheckoutBar(context, cart),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('Keranjang masih kosong',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Text('Yuk, tambahkan es teh favoritmu!',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGrey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Lihat Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartProvider cart) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.paleGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                '${cart.totalItems} item dalam keranjang',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Cart items
        ...List.generate(cart.items.length, (i) {
          final item = cart.items[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Emoji
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.lightYellow, AppColors.paleGreen]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Text(item.product.emoji,
                            style: const TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text(
                          '${item.sizeLabel} • ${item.sweetness}',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatPrice(item.totalPrice),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                  // Qty controls
                  Column(
                    children: [
                      Row(
                        children: [
                          _SmallQtyBtn(
                            icon: Icons.remove,
                            onTap: () => context.read<CartProvider>().decreaseQty(i),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${item.quantity}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 16)),
                          ),
                          _SmallQtyBtn(
                            icon: Icons.add,
                            onTap: () => context.read<CartProvider>().increaseQty(i),
                            isPrimary: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => context.read<CartProvider>().removeItem(i),
                        child: Text('Hapus',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // Price summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: [
              _PriceRow(label: 'Subtotal', value: formatPrice(cart.subtotal)),
              const SizedBox(height: 8),
              _PriceRow(label: 'Ongkir', value: 'Dihitung saat checkout'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: AppColors.paleGreen, thickness: 2),
              ),
              _PriceRow(
                label: 'Total',
                value: formatPrice(cart.subtotal),
                isBold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Bayar',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                Text(
                  formatPrice(cart.subtotal),
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Checkout Sekarang',
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Semua?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Semua item akan dihapus dari keranjang.',
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal',
                style: GoogleFonts.poppins(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  const _SmallQtyBtn({required this.icon, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isPrimary ? AppColors.primaryGreen : AppColors.paleGreen, width: 1.5),
        ),
        child: Icon(icon,
            color: isPrimary ? Colors.white : AppColors.primaryGreen, size: 16),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _PriceRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: isBold ? AppColors.textDark : AppColors.textGrey)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: isBold ? 16 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? AppColors.primaryGreen : AppColors.textDark)),
      ],
    );
  }
}
