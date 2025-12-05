// lib/utils/colors.dart
// Defines the color scheme for the entire application
// Maintains consistency across all UI components

import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Accent colors
  static const Color accent = Color(0xFF03A9F4);

  // Task type colors
  static const Color assignment = Color(0xFF2196F3);
  static const Color quiz = Color(0xFFFF9800);
  static const Color exam = Color(0xFFF44336);
  static const Color project = Color(0xFF4CAF50);

  // UI colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}
