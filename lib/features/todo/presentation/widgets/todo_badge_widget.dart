import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_text_styles.dart';

class TodoBadgeWidget extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const TodoBadgeWidget({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    // Determine color based on badge label
    if (label == 'Request') return const Color(0xFF7C3AED); // Purple
    if (label.contains('Store Visits'))
      return const Color(0xFFFB923C); // Orange
    if (label == 'Draft') return const Color(0xFF6B7280); // Grey
    if (label == 'Form') return const Color(0xFF3B82F6); // Blue
    if (label == 'Compliance') return const Color(0xFFEF4444); // Red
    if (label == 'Urgent') return const Color(0xFFDC2626); // Dark Red
    if (label == 'Report') return const Color(0xFF10B981); // Green

    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
