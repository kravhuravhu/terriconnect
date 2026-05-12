import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color primaryOrange = Color(0xFFFF6522);
  static const Color primaryDark = Color(0xFFE55A1A);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color successGreen = Color(0xFF4CAF50);
  
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.light(
      primary: primaryOrange,
      secondary: accentBlue,
      tertiary: successGreen,
    ),
    fontFamily: GoogleFonts.ubuntu().fontFamily, 
    textTheme: GoogleFonts.ubuntuTextTheme(), 
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: primaryOrange,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
  
  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,
      secondary: accentBlue,
      tertiary: successGreen,
      surface: Color(0xFF1E1E2E),
      background: Color(0xFF121212),
    ),
    fontFamily: GoogleFonts.ubuntu().fontFamily,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: primaryOrange,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}