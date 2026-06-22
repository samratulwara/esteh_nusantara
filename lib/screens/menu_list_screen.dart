import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../models/cart_provider.dart';


import 'cart_screen.dart';
import '../widgets/product_image_widget.dart';
import 'product_detail_screen.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Tea Series', 'Milk Tea Series', 'Macchiato Series', 'Herbal Series', 'Jajanan Dimsum', 'Aneka Gorengan'];

  final Map<String, Map<String, dynamic>> _categoryMeta = {
    'Tea Series': {
      'icon': '🍵',
      'gradientColors': <Color>[Color(0xFF66BB6A), Color(0xFF2D7A3A)],
      'desc': '10 Varian Teh Segar',
    },
    'Milk Tea Series': {
      'icon': '🧋',
      'gradientColors': <Color>[Color(0xFFFFB74D), Color(0xFFE65100)],
      'desc': '10 Varian Milk Tea',
    },
    'Macchiato Series': {
      'icon': '☕',
      'gradientColors': <Color>[Color(0xFFF06292), Color(0xFF880E4F)],
      'desc': '4 Varian Macchiato',
    },
    'Herbal Series': {
      'icon': '🌿',
      'gradientColors': <Color>[Color(0xFFEF5350), Color(0xFF7B1FA2)],
      'desc': '4 Varian Herbal Hangat',
    },
    'Jajanan Dimsum': {
      'icon': '🥟',
      'gradientColors': <Color>[Color(0xFFFFB300), Color(0xFFE65100)],
      'desc': 'Aneka Jajanan Dimsum Zara',
    },
    'Aneka Gorengan': {
      'icon': '🍟',
      'gradientColors': <Color>[Color(0xFFFFD54F), Color(0xFFBF360C)],
      'desc': '6 Menu Gorengan Renyah',
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppColors.softGreenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Menu',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white)),
            Text('Es Teh Nusantara',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 26),
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
                            fontSize: 9, fontWeight: FontWeight.w800,
                            color: AppColors.darkGreen)),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: _tabs.map((t) {
            final meta = _categoryMeta[t]!;
            return Tab(text: '${meta['icon']} $t');
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((cat) => _buildCategoryTab(cat)).toList(),
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    final products = dummyProducts.where((p) => p.category == category).toList();
    final meta = _categoryMeta[category]!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Banner
        _CategoryBanner(category: category, meta: meta, count: products.length),
        const SizedBox(height: 14),

        // Grid produk — 3 kolom, kartu kecil ~10x20 feel
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => _MenuCard(product: products[i]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CategoryBanner extends StatelessWidget {
  final String category;
  final Map<String, dynamic> meta;
  final int count;
  const _CategoryBanner({required this.category, required this.meta, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: List<Color>.from(meta['gradientColors']),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (meta['gradientColors'] as List<Color>)[1].withValues(alpha: 0.3),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(meta['desc'],
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$count menu',
                      style: GoogleFonts.poppins(
                          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
          ),
          Text(meta['icon'], style: const TextStyle(fontSize: 48)),
        ],
      ),
    );
  }
}

class _MenuCard extends StatefulWidget {
  final Product product;
  const _MenuCard({required this.product});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _pressed = false;

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inCart = cart.isInCart(widget.product.id);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: widget.product)));
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar produk
              Expanded(
                child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: ProductImageWidget(
                      imagePath: widget.product.imagePath,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (widget.product.isBestSeller)
                    Positioned(
                      top: 5, right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('🔥',
                            style: GoogleFonts.poppins(fontSize: 9)),
                      ),
                    ),
                  if (inCart)
                    Positioned(
                      top: 5, left: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: AppColors.primaryGreen, shape: BoxShape.circle),
                        child: Text('${cart.getItemCount(widget.product.id)}',
                            style: GoogleFonts.poppins(
                                fontSize: 9, fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ),
                ],
              ),
              ),

              // Info
              Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.product.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: AppColors.textDark),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(formatPrice(widget.product.price),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color: AppColors.primaryGreen)),
                      const SizedBox(height: 5),
                      // Tombol tambah
                      GestureDetector(
                        onTap: () {
                          context.read<CartProvider>().addItem(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('🛒 ${widget.product.name} ditambahkan!'),
                            backgroundColor: AppColors.primaryGreen,
                            duration: const Duration(milliseconds: 1000),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: inCart ? AppColors.primaryYellow : AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            inCart ? Icons.check : Icons.add,
                            color: inCart ? AppColors.darkGreen : Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}