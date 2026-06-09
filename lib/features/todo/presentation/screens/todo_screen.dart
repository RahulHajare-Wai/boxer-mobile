import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../router/app_routes.dart';
import '../../data/models/todo_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/todo_list_widget.dart';
import '../widgets/todo_status_tabs_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedStatusIndex = 0;

  void _addTodo() {
    Navigator.of(context).pushNamed(AppRoutes.createTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final totalCount = TodoModel.getSampleTodos().length;

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  TodoStatusTabsWidget(
                    selectedIndex: _selectedStatusIndex,
                    onChanged: (index) {
                      setState(() {
                        _selectedStatusIndex = index;
                      });
                    },
                    counts: {0: totalCount},
                  ),
                  const Expanded(child: TodoListWidget()),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: AppColors.navBarColor,
        foregroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
