import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/tasks/presentation/screens/tasks_screen.dart';
import '../features/todo/presentation/bloc/create_todo_bloc.dart';
import '../features/todo/presentation/screens/create_todo_screen.dart';
import '../features/todo/presentation/screens/todo_screen.dart';
import 'app_routes.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.tasks:
        return MaterialPageRoute(builder: (_) => const TasksScreen());
      case AppRoutes.todo:
        return MaterialPageRoute(builder: (_) => const TodoScreen());
      case AppRoutes.createTodo:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CreateTodoBloc>(),
            child: const CreateTodoScreen(),
          ),
        );
      case AppRoutes.splash:
      case AppRoutes.dashboard:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
