import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ana Renklerimiz
  static const Color primaryColor = Color(0xFF00897B);
  static const Color accentColor = Color(0xFFFFA000);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);

  // TextTheme'i, her bir stil için "Open Sans" fontunu manuel olarak belirleyerek oluşturuyoruz.
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.openSans(textStyle: base.displayLarge),
      displayMedium: GoogleFonts.openSans(textStyle: base.displayMedium),
      displaySmall: GoogleFonts.openSans(textStyle: base.displaySmall),
      headlineMedium: GoogleFonts.openSans(textStyle: base.headlineMedium),
      headlineSmall: GoogleFonts.openSans(textStyle: base.headlineSmall),
      titleLarge: GoogleFonts.openSans(textStyle: base.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      titleMedium: GoogleFonts.openSans(textStyle: base.titleMedium),
      titleSmall: GoogleFonts.openSans(textStyle: base.titleSmall),
      bodyLarge: GoogleFonts.openSans(textStyle: base.bodyLarge),
      bodyMedium: GoogleFonts.openSans(textStyle: base.bodyMedium),
      labelLarge: GoogleFonts.openSans(textStyle: base.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
      bodySmall: GoogleFonts.openSans(textStyle: base.bodySmall),
      labelSmall: GoogleFonts.openSans(textStyle: base.labelSmall),
    );
  }

  // Açık Tema (Light Theme)
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: lightBackgroundColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0.5,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.openSans( // Değiştirildi
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Koyu Tema (Dark Theme)
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: darkBackgroundColor,
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: AppBarTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 0.5,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.openSans( // Değiştirildi
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: _buildTextTheme(ThemeData.dark().textTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF1E1E1E),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E),
    ),
  );
}