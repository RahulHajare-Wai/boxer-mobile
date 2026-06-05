import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
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
          tabCounts: {0: '${_todos.length}', 1: '0', 2: '${_todos.length}'},
        ),
        const SizedBox(height: 8),
        // Todo sections
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Draft section
                TodoSectionWidget(
                  sectionTitle: 'Draft',
                  todos: _todos.where((t) => t.section == 'draft').toList(),
                  onItemTap: () {},
                ),
                // Upcoming section
                TodoSectionWidget(
                  sectionTitle: 'Upcoming',
                  todos: _todos.where((t) => t.section == 'upcoming').toList(),
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
