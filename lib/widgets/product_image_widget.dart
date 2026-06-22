import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget gambar produk:
/// - Jika imagePath ada & file tersedia → tampilkan gambar
/// - Jika belum ada gambar → tampilkan placeholder abu-abu
class ProductImageWidget extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImageWidget({
    super.key,
    required this.imagePath,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath != null && imagePath!.isNotEmpty) {
      imageWidget = Image.asset(
        imagePath!,
        fit: fit,
        width: double.infinity,
        height: height,
        errorBuilder: (_, __, ___) => _buildPlaceholder(height),
      );
    } else {
      imageWidget = _buildPlaceholder(height);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildPlaceholder(double? h) {
    final isInfinite = h == null || h == double.infinity;
    final iconSize = isInfinite ? 40.0 : (h * 0.35).clamp(16.0, 60.0);
    return Container(
      width: double.infinity,
      height: isInfinite ? null : h,
      color: const Color(0xFFF0F0F0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: isInfinite ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Icon(Icons.image_outlined, size: iconSize, color: const Color(0xFFBDBDBD)),
          const SizedBox(height: 4),
          Text(
            'Tambah Foto',
            style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}