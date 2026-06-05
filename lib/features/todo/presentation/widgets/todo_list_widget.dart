import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
import '../../../../../core/constants/app_strings.dart';
import 'todo_search_filter_bar_widget.dart';
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
  String _searchQuery = '';

  List<TodoModel> get _filteredTodos {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _todos;

    return _todos.where((t) {
      final title = t.title.toLowerCase();
      final subtitle = (t.subtitle ?? '').toLowerCase();
      return title.contains(q) || subtitle.contains(q);
    }).toList();
  }

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
        TodoSearchFilterBarWidget(
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onFilterPressed: null,
          onSortPressed: null,
        ),
        // Todo sections
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Draft section
                TodoSectionWidget(
                  sectionTitle: AppStrings.todoSectionDraft,
                  todos: _filteredTodos
                      .where((t) => t.section == TodoModel.sectionDraft)
                      .toList(),
                  onItemTap: () {},
                ),
                // Upcoming section
                TodoSectionWidget(
                  sectionTitle: AppStrings.todoSectionUpcoming,
                  todos: _filteredTodos
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
