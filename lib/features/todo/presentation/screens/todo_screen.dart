import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/todo_list_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _addTodo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new todo functionality coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return Stack(
              children: [
                // Todo list content
                const TodoListWidget(),
                // User profile button
                Positioned(
                  top: 16,
                  right: 16,
                  child: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.read<AuthBloc>().add(const LogoutRequested());
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.login);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text(AppStrings.logout),
                      ),
                    ],
                    child: Text(
                      state.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
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
