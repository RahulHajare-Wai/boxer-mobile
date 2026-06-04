import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {
  const GetTasksEvent({this.userId});

  final String? userId;

  @override
  List<Object?> get props => [userId];
}

class AddTaskEvent extends TaskEvent {
  const AddTaskEvent({required this.title, this.description});

  final String title;
  final String? description;

  @override
  List<Object?> get props => [title, description];
}

class UpdateTaskEvent extends TaskEvent {
  const UpdateTaskEvent({required this.taskId, required this.title, this.description, this.isCompleted});

  final String taskId;
  final String title;
  final String? description;
  final bool? isCompleted;

  @override
  List<Object?> get props => [taskId, title, description, isCompleted];
}

class DeleteTaskEvent extends TaskEvent {
  const DeleteTaskEvent({required this.taskId});

  final String taskId;

  @override
  List<Object?> get props => [taskId];
}
