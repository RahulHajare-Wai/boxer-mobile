import 'package:flutter/material.dart';

import '../../../../../core/config/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class TodoSearchFilterBarWidget extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSortPressed;

  const TodoSearchFilterBarWidget({
    super.key,
    this.onSearchChanged,
    this.onFilterPressed,
    this.onSortPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onFilterPressed,
            tooltip: AppStrings.todoFilter,
            icon: const Icon(Icons.filter_alt_outlined),
            color: AppColors.textSecondary,
          ),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.todoSearchHint,
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: AppColors.textSecondary,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onSortPressed,
            tooltip: AppStrings.todoSort,
            icon: const Icon(Icons.tune_rounded),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
