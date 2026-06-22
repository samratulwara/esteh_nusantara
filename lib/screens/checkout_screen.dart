import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../models/cart_provider.dart';
import '../models/cart_item.dart';
import 'order_success_screen.dart';

// =====================================================
// GANTI NOMOR HP PEMILIK TOKO DI SINI ↓
const String nomorWaPemilik = '6285199107077'; // format: 62xxxxxxxxxx
// =====================================================

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _catatanCtrl = TextEditingController();

  String _metodePembayaran = 'Tunai (COD)';
  String _metodePengiriman = 'Antar ke Lokasi';
  bool _isLoading = false;

  final List<String> metodePembayaranList = [
    'Tunai (COD)',
    'Transfer Bank',
    'QRIS / E-Wallet',
  ];

  final List<String> metodePengirimanList = [
    'Antar ke Lokasi',
    'Ambil Sendiri (Pick-up)',
  ];

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _teleponCtrl.dispose();
    _alamatCtrl.dispose();
    _catatanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.softGreenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text('Checkout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Ringkasan Pesanan
            _SectionTitle(title: '🛒 Ringkasan Pesanan'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryGreen.withValues(alpha: 0.08), blurRadius: 8)
                ],
              ),
              child: Column(
                children: [
                  ...cart.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(item.product.emoji,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600, fontSize: 13)),
                                  Text('${item.size} • ${item.sweetness} • x${item.quantity}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                            Text(formatPrice(item.totalPrice),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.primaryGreen)),
                          ],
                        ),
                      )),
                  const Divider(color: AppColors.paleGreen, thickness: 1.5),
                  _SummaryRow('Subtotal', formatPrice(cart.subtotal)),
                  const SizedBox(height: 4),
                  _SummaryRow(
                    'Ongkir',
                    _metodePengiriman == 'Ambil Sendiri (Pick-up)'
                        ? 'GRATIS ✅'
                        : formatPrice(cart.getDeliveryFee(_metodePengiriman)),
                  ),
                  const SizedBox(height: 4),
                  _SummaryRow('Total', formatPrice(cart.getGrandTotal(_metodePengiriman)), isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Data Pemesan
            _SectionTitle(title: '👤 Data Pemesan'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _namaCtrl,
              label: 'Nama Lengkap',
              hint: 'Contoh: Budi Santoso',
              icon: Icons.person_outline,
              validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _teleponCtrl,
              label: 'Nomor Telepon',
              hint: 'Contoh: 08123456789',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.length < 10 ? 'Nomor telepon tidak valid' : null,
            ),

            const SizedBox(height: 20),

            // Metode Pengiriman
            _SectionTitle(title: '🚗 Metode Pengiriman'),
            const SizedBox(height: 10),
            ...metodePengirimanList.map((m) => _OptionTile(
                  label: m,
                  icon: m.contains('Antar') ? Icons.delivery_dining : Icons.store_outlined,
                  isSelected: _metodePengiriman == m,
                  onTap: () => setState(() => _metodePengiriman = m),
                )),

            if (_metodePengiriman == 'Antar ke Lokasi') ...[
              const SizedBox(height: 12),
              _buildTextField(
                controller: _alamatCtrl,
                label: 'Alamat Pengiriman',
                hint: 'Jl. Contoh No. 1, Kel. ...',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (v) =>
                    _metodePengiriman == 'Antar ke Lokasi' && (v == null || v.isEmpty)
                        ? 'Alamat wajib diisi'
                        : null,
              ),
            ],

            const SizedBox(height: 20),

            // Metode Pembayaran
            _SectionTitle(title: '💳 Metode Pembayaran'),
            const SizedBox(height: 10),
            ...metodePembayaranList.map((m) => _OptionTile(
                  label: m,
                  icon: m.contains('Tunai')
                      ? Icons.money
                      : m.contains('Transfer')
                          ? Icons.account_balance_outlined
                          : Icons.qr_code_rounded,
                  isSelected: _metodePembayaran == m,
                  onTap: () => setState(() => _metodePembayaran = m),
                )),

            const SizedBox(height: 20),

            // Catatan
            _SectionTitle(title: '📝 Catatan Tambahan (Opsional)'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _catatanCtrl,
              label: 'Catatan',
              hint: 'Contoh: Tolong es batu terpisah ya',
              icon: Icons.note_outlined,
              maxLines: 2,
              isRequired: false,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _submitOrder(context, cart),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  'Pesan Sekarang  ${formatPrice(cart.getGrandTotal(_metodePengiriman))}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: isRequired ? validator : null,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13),
        hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withValues(alpha: 0.6), fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _submitOrder(BuildContext context, CartProvider cart) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Buat nomor pesanan unik
    final now = DateTime.now();
    final noPesanan = 'ETN${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}${now.millisecond}';

    // Simpan data pesanan sebelum cart dikosongkan
    final items = List<CartItem>.from(cart.items);
    final grandTotal = cart.getGrandTotal(_metodePengiriman);
    final deliveryFee = cart.getDeliveryFee(_metodePengiriman);
    final subtotal = cart.subtotal;

    final orderData = {
      'noPesanan': noPesanan,
      'nama': _namaCtrl.text,
      'telepon': _teleponCtrl.text,
      'alamat': _metodePengiriman == 'Antar ke Lokasi' ? _alamatCtrl.text : 'Ambil di toko',
      'catatan': _catatanCtrl.text,
      'pembayaran': _metodePembayaran,
      'pengiriman': _metodePengiriman,
      'total': grandTotal,
      'subtotal': subtotal,
      'ongkir': deliveryFee,
      'items': items.map((item) => {
        'name': item.product.name,
        'size': item.size,
        'sweetness': item.sweetness,
        'qty': item.quantity,
        'price': item.totalPrice,
      }).toList(),
    };

    // Kirim WhatsApp ke pemilik toko
    await _kirimWhatsApp(
      items: items,
      orderData: orderData,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      grandTotal: grandTotal,
      noPesanan: noPesanan,
    );

    cart.clearCart();
    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderData: orderData)),
      (route) => route.isFirst,
    );
  }

  Future<void> _kirimWhatsApp({
    required List<CartItem> items,
    required Map<String, dynamic> orderData,
    required double subtotal,
    required double deliveryFee,
    required double grandTotal,
    required String noPesanan,
  }) async {
    // Susun daftar item pesanan
    final itemLines = items.map((item) {
      final harga = item.totalPrice.toStringAsFixed(0)
          .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
      return '  • ${item.product.name} (${item.size}, ${item.sweetness}) x${item.quantity} = Rp $harga';
    }).join('\n');

    String formatRp(double v) => 'Rp ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

    final pesan = '''
🛒 *PESANAN BARU - Es Teh Nusantara*
━━━━━━━━━━━━━━━━━━━━
📋 No. Pesanan: *#$noPesanan*

👤 *Data Pemesan:*
  Nama     : ${orderData['nama']}
  Telepon  : ${orderData['telepon']}
  Pengiriman: ${orderData['pengiriman']}
  Alamat   : ${orderData['alamat']}
  Pembayaran: ${orderData['pembayaran']}
${orderData['catatan'].toString().isNotEmpty ? '  Catatan : ${orderData['catatan']}' : ''}

🧾 *Detail Pesanan:*
$itemLines

━━━━━━━━━━━━━━━━━━━━
  Subtotal  : ${formatRp(subtotal)}
  Ongkir    : ${formatRp(deliveryFee)}
💰 *TOTAL   : ${formatRp(grandTotal)}*
━━━━━━━━━━━━━━━━━━━━
Mohon segera dikonfirmasi 🙏
''';

    final encoded = Uri.encodeComponent(pesan);
    final url = Uri.parse('https://wa.me/$nomorWaPemilik?text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark));
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _OptionTile(
      {required this.label,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.paleGreen : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.paleGreen, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primaryGreen : AppColors.textGrey, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryGreen : AppColors.textDark)),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 22),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _SummaryRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: isBold ? 14 : 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: isBold ? AppColors.textDark : AppColors.textGrey)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? AppColors.primaryGreen : AppColors.textDark)),
      ],
    );
  }
}
