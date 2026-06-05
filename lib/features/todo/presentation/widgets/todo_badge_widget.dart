import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_strings.dart';

class _TodoBadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const _TodoBadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}

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

  _TodoBadgeStyle _getBadgeStyle() {
    Color tint(Color base) => base.withValues(alpha: 0.14);

    if (label == AppStrings.todoBadgeRequest) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.info),
        textColor: AppColors.info,
        icon: Icons.flag_outlined,
      );
    }

    if (label.contains(AppStrings.todoBadgeStoreVisitsGmGe)) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.warning),
        textColor: AppColors.warning,
        icon: Icons.store,
      );
    }

    if (label == AppStrings.todoBadgeDraft) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.textHint),
        textColor: AppColors.textSecondary,
        icon: null,
      );
    }

    if (label == AppStrings.todoBadgeForm) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.info),
        textColor: AppColors.info,
        icon: Icons.description_outlined,
      );
    }

    if (label == AppStrings.todoBadgeCompliance) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.error),
        textColor: AppColors.error,
        icon: Icons.check_circle_outline,
      );
    }

    if (label == AppStrings.todoBadgeStockManagement) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.error),
        textColor: AppColors.error,
        icon: Icons.inventory_2_outlined,
      );
    }

    if (label == AppStrings.todoBadgePendingValidation) {
      return _TodoBadgeStyle(
        backgroundColor: AppColors.textPrimary,
        textColor: AppColors.surface,
        icon: Icons.pending_actions,
      );
    }

    if (label == AppStrings.todoBadgeUrgent) {
      return _TodoBadgeStyle(
        backgroundColor: AppColors.textPrimary,
        textColor: AppColors.surface,
        icon: Icons.priority_high,
      );
    }

    if (label == AppStrings.todoBadgeReport) {
      return _TodoBadgeStyle(
        backgroundColor: tint(AppColors.success),
        textColor: AppColors.success,
        icon: Icons.assessment_outlined,
      );
    }

    return _TodoBadgeStyle(
      backgroundColor: tint(AppColors.primary),
      textColor: AppColors.primary,
      icon: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _getBadgeStyle();
    final resolvedBackgroundColor = backgroundColor ?? style.backgroundColor;
    final resolvedTextColor = textColor ?? style.textColor;
    final icon = style.icon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: resolvedTextColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: resolvedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
