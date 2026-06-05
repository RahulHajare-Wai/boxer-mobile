import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_text_styles.dart';
import 'todo_item_widget.dart';

class TodoSectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<TodoModel> todos;
  final VoidCallback? onItemTap;

  const TodoSectionWidget({
    super.key,
    required this.sectionTitle,
    required this.todos,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            sectionTitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: todos
                .map((todo) => TodoItemWidget(todo: todo, onTap: onItemTap))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
