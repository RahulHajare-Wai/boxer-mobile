import 'package:flutter/material.dart';

import '../../../../../core/config/app_colors.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.navBarColor,
      centerTitle: true,
      leadingWidth: 100,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile icon
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.person,
                color: AppColors.navBarInactive,
              ),
              onPressed: () {
                // TODO: Handle profile tap
              },
            ),
          ),
          // Search icon
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.search,
                color: AppColors.navBarInactive,
              ),
              onPressed: () {
                // TODO: Handle search tap
              },
            ),
          ),
        ],
      ),
      title: SizedBox(
        height: 50,
        child: Image.asset(
          'assets/images/boxer_logo.png',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        // Notification icon
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.navBarInactive,
          ),
          onPressed: () {
            // TODO: Handle notification tap
          },
        ),
        // Chat icon
        IconButton(
          icon: const Icon(
            Icons.chat_outlined,
            color: AppColors.navBarInactive,
          ),
          onPressed: () {
            // TODO: Handle chat tap
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
