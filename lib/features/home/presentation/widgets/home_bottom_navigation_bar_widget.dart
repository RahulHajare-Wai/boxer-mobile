import 'package:flutter/material.dart';

import '../../../../../core/config/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class HomeBottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const HomeBottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.navBarColor,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTabChanged,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 0 ? AppColors.primary : AppColors.navBarInactive,
          ),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.checklist,
            color: currentIndex == 1 ? AppColors.primary : AppColors.navBarInactive,
          ),
          label: AppStrings.todo,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.newspaper,
            color: currentIndex == 2 ? AppColors.primary : AppColors.navBarInactive,
          ),
          label: AppStrings.newsfeed,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.location_on,
            color: currentIndex == 3 ? AppColors.primary : AppColors.navBarInactive,
          ),
          label: AppStrings.sites,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.more_horiz,
            color: currentIndex == 4 ? AppColors.primary : AppColors.navBarInactive,
          ),
          label: AppStrings.more,
        ),
      ],
    );
  }
}
