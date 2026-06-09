import 'package:flutter/material.dart';

import '../../../../../core/config/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../data/models/todo_model.dart';

class CreateTodoSectionSelectorWidget extends StatelessWidget {
  const CreateTodoSectionSelectorWidget({
    required this.selectedSection,
    required this.onSectionChanged,
    super.key,
  });

  final String selectedSection;
  final Function(String) onSectionChanged;

  @override
  Widget build(BuildContext context) {
    final sections = [
      (label: AppStrings.todoSectionDraft, value: TodoModel.sectionDraft),
      (label: AppStrings.todoSectionUpcoming, value: TodoModel.sectionUpcoming),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createTodoSectionLabel,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: sections.map((section) {
            final isSelected = selectedSection == section.value;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSectionChanged(section.value),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      section.label,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
