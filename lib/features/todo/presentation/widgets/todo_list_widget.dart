import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
import '../../../../../core/constants/app_strings.dart';
import 'todo_tabs_widget.dart';
import 'todo_section_widget.dart';

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({super.key});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  int _selectedTabIndex = 0;
  final List<TodoModel> _todos = TodoModel.getSampleTodos();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs
        TodoTabsWidget(
          selectedTabIndex: _selectedTabIndex,
          onTabChanged: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          tabCounts: {0: _todos.length, 1: 0, 2: _todos.length},
        ),
        const SizedBox(height: 8),
        // Todo sections
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Draft section
                TodoSectionWidget(
                  sectionTitle: AppStrings.todoSectionDraft,
                  todos: _todos
                      .where((t) => t.section == TodoModel.sectionDraft)
                      .toList(),
                  onItemTap: () {},
                ),
                // Upcoming section
                TodoSectionWidget(
                  sectionTitle: AppStrings.todoSectionUpcoming,
                  todos: _todos
                      .where((t) => t.section == TodoModel.sectionUpcoming)
                      .toList(),
                  onItemTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
