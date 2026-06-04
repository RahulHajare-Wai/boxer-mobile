import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    on<GetTasksEvent>(_onGetTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onGetTasks(
    GetTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(const TaskLoading());
      // TODO: Implement get tasks logic
      emit(const TaskLoaded(tasks: []));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(const TaskLoading());
      // TODO: Implement add task logic
      emit(const TaskOperationSuccess(message: 'Task added successfully'));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(const TaskLoading());
      // TODO: Implement update task logic
      emit(const TaskOperationSuccess(message: 'Task updated successfully'));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(const TaskLoading());
      // TODO: Implement delete task logic
      emit(const TaskOperationSuccess(message: 'Task deleted successfully'));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
