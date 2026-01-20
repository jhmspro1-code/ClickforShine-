 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _darkBackground = Color(0xFF0F0F0F);
  static const Color _darkSurface = Color(0xFF1A1A1A);
  static const Color _primaryGold = Color(0xFFD4AF37);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: _primaryGold,
        onPrimary: Colors.black,
        surface: _darkSurface,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
    );
  }
}
