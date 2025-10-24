import 'package:flutter/material.dart';

/// Application-wide color constants
/// Follows the pink/rose theme from the design mockups
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFFFF69B4); // Hot Pink
  static const Color primaryLight = Color(0xFFFFB6D9);
  static const Color primaryDark = Color(0xFFFF1493);
  
  // Background Colors
  static const Color background = Color(0xFFFFFAFC);
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // UI Elements
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  
  // Rating Star
  static const Color star = Color(0xFFFFD700);
  
  // Discount Badge
  static const Color discount = Color(0xFFFF5252);
}