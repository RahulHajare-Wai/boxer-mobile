import 'package:equatable/equatable.dart';

import '../../data/models/todo_model.dart';

abstract class CreateTodoState extends Equatable {
  const CreateTodoState();

  @override
  List<Object?> get props => [];
}

class CreateTodoInitial extends CreateTodoState {
  const CreateTodoInitial();
}

class CreateTodoLoading extends CreateTodoState {
  const CreateTodoLoading();
}

class CreateTodoSuccess extends CreateTodoState {
  const CreateTodoSuccess(this.todo);

  final TodoModel todo;

  @override
  List<Object?> get props => [todo];
}

class CreateTodoError extends CreateTodoState {
  const CreateTodoError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CreateTodoFormReset extends CreateTodoState {
  const CreateTodoFormReset();
}
