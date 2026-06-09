import 'package:flutter/material.dart';

import '../../../../../core/config/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../data/models/todo_model.dart';

class CreateTodoPrioritySelectorWidget extends StatelessWidget {
  const CreateTodoPrioritySelectorWidget({
    required this.selectedPriority,
    required this.onPriorityChanged,
    super.key,
  });

  final String? selectedPriority;
  final Function(String?) onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    final priorities = [
      (label: AppStrings.createTodoPriorityNone, value: null),
      (
        label: AppStrings.createTodoPriorityRequest,
        value: TodoModel.priorityRequest,
      ),
      (
        label: AppStrings.createTodoPriorityStoreVisit,
        value: TodoModel.priorityStoreVisit,
      ),
      (
        label: AppStrings.createTodoPriorityCompliance,
        value: TodoModel.priorityCompliance,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createTodoPriorityLabel,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: priorities.map((priority) {
            final isSelected = selectedPriority == priority.value;

            Color backgroundColor = AppColors.surface;
            Color textColor = AppColors.textPrimary;

            if (isSelected) {
              if (priority.value == TodoModel.priorityCompliance) {
                backgroundColor = AppColors.error;
                textColor = Colors.white;
              } else if (priority.value == TodoModel.priorityStoreVisit) {
                backgroundColor = AppColors.warning;
                textColor = Colors.white;
              } else if (priority.value == TodoModel.priorityRequest) {
                backgroundColor = AppColors.info;
                textColor = Colors.white;
              } else {
                backgroundColor = AppColors.primary;
                textColor = Colors.white;
              }
            }

            return GestureDetector(
              onTap: () => onPriorityChanged(priority.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: isSelected ? backgroundColor : AppColors.divider,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority.label,
                  style: AppTextStyles.titleSmall.copyWith(color: textColor),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
