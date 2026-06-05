import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_text_styles.dart';
import 'todo_badge_widget.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300] ?? const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and date row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dot indicator
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 12),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getPriorityColor(),
                    ),
                  ),
                ),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (todo.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Due date
                if (todo.dueDate != null)
                  Text(
                    todo.dueDate!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Badges
            if (todo.badges.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: todo.badges
                    .map((badge) => TodoBadgeWidget(label: badge))
                    .toList(),
              ),
            // Assigned to and due time
            if (todo.assignedTo != null || todo.dueTime != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (todo.assignedTo != null) ...[
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        todo.assignedTo!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  if (todo.dueTime != null) ...[
                    if (todo.assignedTo != null) const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        todo.dueTime!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    if (todo.priority == 'compliance') return const Color(0xFFEF4444);
    if (todo.priority == 'request') return const Color(0xFF7C3AED);
    if (todo.priority == 'store_visit') return const Color(0xFFFB923C);
    return AppColors.primary;
  }
}
