import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color.fromRGBO(144, 7, 7, 1);
  static const Color primaryDark = Color.fromARGB(255, 192, 29, 21);
  static const Color primaryLight = Color.fromARGB(255, 249, 165, 144);

  // Accent
  static const Color accent = Color(0xFFFF6F00);
  static const Color accentLight = Color(0xFFFFCA28);

  // Background
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF039BE5);

  // Divider / Border
  static const Color navBarColor = Color(0xFFDBD5D5);
  static const Color navBarInactive = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);

  // Transparent
  static const Color transparent = Colors.transparent;
}
