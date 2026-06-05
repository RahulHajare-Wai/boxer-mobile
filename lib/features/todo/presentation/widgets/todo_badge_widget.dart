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

  Map<String, dynamic> _getBadgeStyle() {
    // Determine colors and icon based on badge label
    if (label == 'Request') {
      return {
        'backgroundColor': const Color(0xFFEDE9FE), // Light purple
        'textColor': const Color(0xFF7C3AED), // Purple
        'icon': Icons.flag_outlined,
      };
    }
    if (label.contains('Store Visits')) {
      return {
        'backgroundColor': const Color(0xFFFED7AA), // Light orange
        'textColor': const Color(0xFFB45309), // Dark orange
        'icon': Icons.store,
      };
    }
    if (label == 'Draft') {
      return {
        'backgroundColor': const Color(0xFFE5E7EB), // Light grey
        'textColor': const Color(0xFF6B7280), // Dark grey
        'icon': null,
      };
    }
    if (label == 'Form') {
      return {
        'backgroundColor': const Color(0xFFDEF0FE), // Light blue
        'textColor': const Color(0xFF0369A1), // Dark blue
        'icon': Icons.description_outlined,
      };
    }
    if (label == 'Compliance') {
      return {
        'backgroundColor': const Color(0xFFFECDCD), // Light red
        'textColor': const Color(0xFFDC2626), // Dark red
        'icon': Icons.check_circle_outline,
      };
    }
    if (label == 'Urgent') {
      return {
        'backgroundColor': const Color(0xFF1F2937), // Dark grey/navy
        'textColor': Colors.white,
        'icon': Icons.priority_high,
      };
    }
    if (label == 'Report') {
      return {
        'backgroundColor': const Color(0xFFD1FAE5), // Light green
        'textColor': const Color(0xFF065F46), // Dark green
        'icon': Icons.assessment_outlined,
      };
    }
    if (label == 'Pending validation') {
      return {
        'backgroundColor': const Color(0xFF1F2937), // Dark navy
        'textColor': Colors.white,
        'icon': Icons.pending_actions,
      };
    }
    if (label == 'Stock management') {
      return {
        'backgroundColor': const Color(0xFFFECDCD), // Light red
        'textColor': const Color(0xFFDC2626), // Dark red
        'icon': Icons.inventory_2_outlined,
      };
    }

    return {
      'backgroundColor': AppColors.primary.withValues(alpha: 0.1),
      'textColor': AppColors.primary,
      'icon': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = _getBadgeStyle();
    final bgColor = backgroundColor ?? style['backgroundColor'] as Color;
    final textColor = this.textColor ?? style['textColor'] as Color;
    final icon = style['icon'] as IconData?;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
