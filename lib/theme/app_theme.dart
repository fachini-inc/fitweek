import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryDark = Color(0xFF3A3A3A);
  static const Color primary = Color(0xFF616161);
  static const Color border = Color(0xFFE0E0E0);
  static const Color restColor = Color(0xFF9E9E9E);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primaryDark,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryDark,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryDark, width: 1.4),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            color: textPrimary, fontWeight: FontWeight.w700, fontSize: 22),
        titleMedium: TextStyle(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 17),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primaryDark
              : Colors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primaryDark.withOpacity(0.4)
              : border,
        ),
      ),
    );
  }
}
