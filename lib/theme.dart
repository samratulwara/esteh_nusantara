import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Hijau soft sebagai warna utama background
  static const Color primaryGreen    = Color(0xFF2D7A3A);
  static const Color lightGreen      = Color(0xFF4CAF50);
  static const Color softGreenBg     = Color(0xFFEFF7F0);   // latar hijau soft
  static const Color softGreenCard   = Color(0xFFE3F2E6);   // card hijau soft
  static const Color paleGreen       = Color(0xFFC8E6C9);
  static const Color darkGreen       = Color(0xFF1B5E20);
  static const Color primaryYellow   = Color(0xFFF5C518);
  static const Color deepYellow      = Color(0xFFE6A800);
  static const Color lightYellow     = Color(0xFFFFF9C4);
  static const Color accentOrange    = Color(0xFFFF8C00);
  static const Color background      = Color(0xFFEFF7F0);   // hijau soft
  static const Color cardWhite       = Color(0xFFFFFFFF);
  static const Color textDark        = Color(0xFF1A2E1A);
  static const Color textGrey        = Color(0xFF5A7A5A);
}

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      primary: AppColors.primaryGreen,
      secondary: AppColors.primaryYellow,
      surface: AppColors.cardWhite,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700,
      ),
    ),
    scaffoldBackgroundColor: AppColors.softGreenBg,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    cardTheme: CardThemeData(
  color: AppColors.cardWhite,
  elevation: 3,
  shadowColor: AppColors.primaryGreen.withOpacity(0.15),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16)),
    ),
  );
}
