import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/todo_model.dart';
import 'create_todo_event.dart';
import 'create_todo_state.dart';

class CreateTodoBloc extends Bloc<CreateTodoEvent, CreateTodoState> {
  CreateTodoBloc() : super(const CreateTodoInitial()) {
    on<CreateTodoRequested>(_onCreateTodoRequested);
    on<ResetCreateTodoForm>(_onResetForm);
  }

  Future<void> _onCreateTodoRequested(
    CreateTodoRequested event,
    Emitter<CreateTodoState> emit,
  ) async {
    emit(const CreateTodoLoading());
    try {
      // Validate required fields
      if (event.title.trim().isEmpty) {
        emit(const CreateTodoError('Please enter a title'));
        return;
      }

      // Generate unique ID
      final todoId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create the todo model
      final newTodo = TodoModel(
        id: todoId,
        title: event.title.trim(),
        subtitle: event.subtitle?.isEmpty ?? true
            ? null
            : event.subtitle?.trim(),
        section: event.section,
        badges: event.badges,
        dueDate: event.dueDate,
        dueTime: event.dueTime,
        priority: event.priority,
        assignedTo: event.assignedTo,
      );

      // Emit success state with the created todo
      emit(CreateTodoSuccess(newTodo));

      // ignore: avoid_print
      print(
        '[CREATE_TODO] Todo created: id=${newTodo.id}, title=${newTodo.title}, section=${newTodo.section}',
      );
    } catch (e) {
      emit(CreateTodoError(e.toString()));
      // ignore: avoid_print
      print('[CREATE_TODO] Error creating todo: $e');
    }
  }

  Future<void> _onResetForm(
    ResetCreateTodoForm event,
    Emitter<CreateTodoState> emit,
  ) async {
    emit(const CreateTodoFormReset());
  }
}
