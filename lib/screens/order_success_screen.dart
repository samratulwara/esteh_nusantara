import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import 'home_screen.dart';


const String nomorWaPemilik = '6282325083731';

class OrderSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  const OrderSuccessScreen({super.key, required this.orderData});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _waSent = false;

  String get orderNumber {
    final now = DateTime.now();
    return 'ETN${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond}';
  }

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)));
    _controller.forward();

    // Auto kirim WA ke pemilik toko setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _kirimNotifWhatsApp();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Buat pesan WhatsApp lengkap ─────────────────────────────────────────
  String _buatPesanWA() {
    final data = widget.orderData;
    final items = data['items'] as List<Map<String, dynamic>>? ?? [];
    final now = DateTime.now();
    final tgl = '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';

    final sb = StringBuffer();
    sb.writeln('🛍️ *PESANAN BARU - ES TEH NUSANTARA*');
    sb.writeln('━━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('📋 No. Pesanan: *#$orderNumber*');
    sb.writeln('🕐 Waktu: $tgl');
    sb.writeln('');
    sb.writeln('👤 *DATA PEMESAN*');
    sb.writeln('Nama     : ${data['nama'] ?? '-'}');
    sb.writeln('Telepon  : ${data['telepon'] ?? '-'}');
    sb.writeln('');
    sb.writeln('🚗 *PENGIRIMAN*');
    sb.writeln('Metode   : ${data['pengiriman'] ?? '-'}');
    if ((data['pengiriman']?.toString() ?? '') == 'Antar ke Lokasi') {
      sb.writeln('Alamat   : ${data['alamat'] ?? '-'}');
    }
    sb.writeln('');
    sb.writeln('💳 *PEMBAYARAN*');
    sb.writeln('Metode   : ${data['pembayaran'] ?? '-'}');
    sb.writeln('');

    // Detail item pesanan
    if (items.isNotEmpty) {
      sb.writeln('🧾 *DETAIL PESANAN*');
      for (final item in items) {
        sb.writeln('• ${item['name']} (${item['size']}, ${item['sweetness']}) x${item['qty']}');
        sb.writeln('  → ${formatPrice((item['price'] as num).toDouble())}');
      }
      sb.writeln('');
    }

    sb.writeln('━━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('💰 Subtotal  : ${formatPrice((data['subtotal'] as num? ?? 0).toDouble())}');
    sb.writeln('🚚 Ongkir    : ${formatPrice((data['ongkir'] as num? ?? 0).toDouble())}');
    sb.writeln('✅ *TOTAL    : ${formatPrice((data['total'] as num? ?? 0).toDouble())}*');

    if ((data['catatan']?.toString() ?? '').isNotEmpty) {
      sb.writeln('');
      sb.writeln('📝 Catatan: ${data['catatan']}');
    }

    sb.writeln('');
    sb.writeln('_Pesan dikirim otomatis dari Aplikasi Es Teh Nusantara_');
    return sb.toString();
  }

  // ── Kirim ke WhatsApp pemilik ────────────────────────────────────────────
  Future<void> _kirimNotifWhatsApp() async {
    final pesan = Uri.encodeComponent(_buatPesanWA());
    final url = Uri.parse('https://wa.me/$nomorWaPemilik?text=$pesan');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        if (mounted) setState(() => _waSent = true);
      } else {
        _showError();
      }
    } catch (e) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal buka WhatsApp. Pastikan WhatsApp terinstall.',
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.orderData;
    return Scaffold(
      backgroundColor: AppColors.softGreenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Animasi centang
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35),
                      blurRadius: 28, spreadRadius: 4,
                    )],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text('Pesanan Berhasil! 🎉',
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.w800,
                            color: AppColors.textDark),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text('Terima kasih sudah memesan di\nEs Teh Nusantara 🍵',
                        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey, height: 1.5),
                        textAlign: TextAlign.center),

                    const SizedBox(height: 20),

                    // Nomor pesanan
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryYellow),
                      ),
                      child: Column(
                        children: [
                          Text('Nomor Pesanan',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                          Text('#$orderNumber',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.w800,
                                  color: AppColors.darkGreen, letterSpacing: 1)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status WA notif
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _waSent
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _waSent ? AppColors.lightGreen : AppColors.primaryYellow,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(_waSent ? '✅' : '⏳', style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _waSent
                                  ? 'Notifikasi WhatsApp berhasil dikirim ke pemilik toko!'
                                  : 'Mengirim notifikasi ke WhatsApp pemilik toko...',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: _waSent ? AppColors.primaryGreen : AppColors.accentOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Detail pesanan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.08),
                          blurRadius: 10, offset: const Offset(0, 3),
                        )],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Detail Pesanan',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 12),
                          _DetailRow(icon: Icons.person_outline, label: 'Nama',
                              value: (data['nama'] ?? '-').toString()),
                          _DetailRow(icon: Icons.phone_outlined, label: 'Telepon',
                              value: (data['telepon'] ?? '-').toString()),
                          _DetailRow(icon: Icons.delivery_dining, label: 'Pengiriman',
                              value: (data['pengiriman'] ?? '-').toString()),
                          if ((data['pengiriman']?.toString() ?? '') == 'Antar ke Lokasi')
                            _DetailRow(icon: Icons.home_outlined, label: 'Alamat',
                                value: (data['alamat'] ?? '-').toString()),
                          _DetailRow(icon: Icons.payment_outlined, label: 'Pembayaran',
                              value: (data['pembayaran'] ?? '-').toString()),
                          if ((data['catatan']?.toString() ?? '').isNotEmpty)
                            _DetailRow(icon: Icons.note_outlined, label: 'Catatan',
                                value: data['catatan'].toString()),
                          const Divider(color: AppColors.paleGreen, thickness: 1.5, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Pembayaran',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                              Text(formatPrice((data['total'] as num? ?? 0).toDouble()),
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, fontWeight: FontWeight.w800,
                                      color: AppColors.primaryGreen)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Estimasi
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.paleGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text('⏱️', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimasi Waktu',
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                              Text(
                                (data['pengiriman']?.toString() ?? '') == 'Antar ke Lokasi'
                                    ? '30 - 45 menit' : '15 - 20 menit',
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w700,
                                    color: AppColors.primaryGreen),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol kirim WA manual (jika auto gagal)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _kirimNotifWhatsApp,
                        icon: const Text('📲', style: TextStyle(fontSize: 18)),
                        label: Text(_waSent ? 'Kirim Ulang ke WhatsApp' : 'Kirim ke WhatsApp Pemilik',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366), // hijau WhatsApp
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tombol kembali beranda
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Kembali ke Beranda'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryGreen),
                        label: Text('Pesan Lagi',
                            style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: AppColors.primaryGreen, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryGreen),
          const SizedBox(width: 10),
          SizedBox(width: 85,
              child: Text(label,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey))),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }
}
