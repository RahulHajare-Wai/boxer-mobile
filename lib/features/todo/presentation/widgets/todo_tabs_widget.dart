import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_text_styles.dart';

class TodoTabsWidget extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;
  final Map<int, String> tabCounts;

  const TodoTabsWidget({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
    required this.tabCounts,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['My to dos', 'To validate', 'All to dos'];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedTabIndex == index;
            final count = tabCounts[index] ?? '0';

            return GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabs[index],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count+',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
