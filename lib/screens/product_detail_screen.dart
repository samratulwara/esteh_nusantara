import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/product.dart';
import '../models/cart_provider.dart';

import 'cart_screen.dart';
import '../widgets/product_image_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = 'M';
  String _selectedSweetness = 'Normal';
  int _quantity = 1;

  final List<String> sweetnessList = ['Kurang Manis', 'Normal', 'Extra Manis'];

  // ── Minuman: hanya ukuran M (sedang) ──
  final List<Map<String, dynamic>> _drinkSizes = [
    {'label': 'M', 'desc': 'Sedang', 'price': 0.0},
  ];

  // ── Dimsum: 1 pcs / 3 pcs / 7 pcs ──
  final List<Map<String, dynamic>> _dimsumSizes = [
    {'label': 'S', 'desc': '1 pcs',  'price': 1500.0},
    {'label': 'M', 'desc': '3 pcs',  'price': 5000.0},
    {'label': 'L', 'desc': '7 pcs',  'price': 10000.0},
  ];

  // ── Gorengan: tanpa pilihan ukuran, harga tetap 1.000 ──
  // (tidak ada size selector, harga langsung dari product.price)

  bool get isDrink =>
      widget.product.category == 'Tea Series' ||
      widget.product.category == 'Milk Tea Series' ||
      widget.product.category == 'Macchiato Series' ||
      widget.product.category == 'Herbal Series';

  bool get isDimsum => widget.product.category == 'Jajanan Dimsum';
  bool get isGorengan => widget.product.category == 'Aneka Gorengan';

  List<Map<String, dynamic>> get currentSizes {
    if (isDrink)   return _drinkSizes;
    if (isDimsum)  return _dimsumSizes;
    return [];
  }

  @override
  void initState() {
    super.initState();
    if (isDrink)    _selectedSize = 'M';
    if (isDimsum)   _selectedSize = 'S';
    if (isGorengan) _selectedSize = '';
  }

  double get totalPrice {
    if (isDimsum) {
      // harga diambil dari pilihan size dimsum
      final sel = _dimsumSizes.firstWhere(
        (s) => s['label'] == _selectedSize,
        orElse: () => _dimsumSizes.first,
      );
      return (sel['price'] as double) * _quantity;
    }
    if (isDrink) {
      // minuman: harga base × 1 (hanya M)
      return widget.product.price * _quantity;
    }
    // gorengan: harga per pcs × qty
    return widget.product.price * _quantity;
  }

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGreenBg,
      body: CustomScrollView(
        slivers: [
          // App Bar with hero image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [_CartIconButton()],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImageWidget(
                    imagePath: widget.product.imagePath,
                    fit: BoxFit.cover,
                  ),
                  if (widget.product.isBestSeller)
                    Positioned(
                      bottom: 16, left: 0, right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('🔥 Menu Terlaris',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGreen)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Category
                  Text(
                    widget.product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.paleGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🌿 ${widget.product.category}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price display
                  Row(
                    children: [
                      Text(
                        'Harga mulai dari',
                        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDimsum
                            ? formatPrice(_dimsumSizes.first['price'])
                            : formatPrice(widget.product.price),
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: AppColors.paleGreen, thickness: 2),
                  const SizedBox(height: 16),

                  // ── SIZE SELECTOR ──
                  if (isDrink) ...[
                    Text('Ukuran',
                      style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    // Hanya tampil 1 tombol: Sedang
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryGreen, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text('M',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.white)),
                              Text('Sedang',
                                style: GoogleFonts.poppins(
                                  fontSize: 11, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (isDimsum) ...[
                    Text('Pilih Porsi',
                      style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Row(
                      children: _dimsumSizes.map((s) {
                        final isSelected = _selectedSize == s['label'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = s['label']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryGreen : AppColors.paleGreen,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(s['desc'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: isSelected ? Colors.white : AppColors.textDark)),
                                Text(formatPrice(s['price']),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: isSelected ? Colors.white70 : AppColors.textGrey)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (isGorengan) ...[
                    Text('Harga per pcs',
                      style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        formatPrice(widget.product.price),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── SWEETNESS (hanya untuk minuman) ──
                  if (isDrink) ...[
                    Text('Tingkat Kemanisan',
                      style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: sweetnessList.map((sw) {
                        final isSelected = _selectedSweetness == sw;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSweetness = sw),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryYellow : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.deepYellow : AppColors.paleGreen,
                                width: 2,
                              ),
                            ),
                            child: Text(sw,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.darkGreen : AppColors.textGrey,
                              )),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── QUANTITY ──
                  Text('Jumlah',
                    style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () { if (_quantity > 1) setState(() => _quantity--); },
                      ),
                      const SizedBox(width: 16),
                      Text('$_quantity',
                        style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                      const SizedBox(width: 16),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity++),
                        isPrimary: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Harga',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                  Text(
                    formatPrice(totalPrice),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  final sizeLabel = isGorengan
                      ? 'Satuan'
                      : isDimsum
                          ? _dimsumSizes.firstWhere(
                              (s) => s['label'] == _selectedSize,
                              orElse: () => _dimsumSizes.first)['desc']
                          : 'Sedang';

                  for (int i = 0; i < _quantity; i++) {
                    context.read<CartProvider>().addItem(
                      widget.product,
                      size: sizeLabel,
                      sweetness: isDrink ? _selectedSweetness : '-',
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ Ditambahkan ke keranjang!'),
                      backgroundColor: AppColors.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_rounded),
                label: const Text('Tambah ke Keranjang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  const _QtyButton({required this.icon, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary ? AppColors.primaryGreen : AppColors.paleGreen, width: 2),
        ),
        child: Icon(icon,
          color: isPrimary ? Colors.white : AppColors.primaryGreen, size: 20),
      ),
    );
  }
}

class _CartIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CartScreen())),
        ),
        if (cart.totalItems > 0)
          Positioned(
            right: 8, top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow, shape: BoxShape.circle),
              child: Text('${cart.totalItems}',
                style: GoogleFonts.poppins(
                  fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
            ),
          ),
      ],
    );
  }
}
