import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // Grey Shades
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);

  // Accent Colors
  static const Color amber = Colors.amber;

  // Background Colors
  static const Color scaffoldBackground = Colors.black;
  static const Color cardBackground = Color(0xFF212121);
  static const Color inputBackground = Color(0xFF212121);
  static const Color imagePlaceholder = Color(0xFF424242);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFBDBDBD);
  static const Color textTertiary = Color(0xFFE0E0E0);

  // Border Colors
  static const Color borderPrimary = Colors.white;
  static Color? borderSecondary = Colors.grey[400];
}
