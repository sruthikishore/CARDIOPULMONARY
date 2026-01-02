import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const section = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(
    fontSize: 14,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const vitals = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}
