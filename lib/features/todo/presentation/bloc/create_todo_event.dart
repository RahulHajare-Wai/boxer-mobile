import 'package:equatable/equatable.dart';

abstract class CreateTodoEvent extends Equatable {
  const CreateTodoEvent();

  @override
  List<Object?> get props => [];
}

class CreateTodoRequested extends CreateTodoEvent {
  const CreateTodoRequested({
    required this.title,
    this.subtitle,
    required this.section,
    this.badges = const [],
    this.dueDate,
    this.dueTime,
    this.priority,
    this.assignedTo,
  });

  final String title;
  final String? subtitle;
  final String section;
  final List<String> badges;
  final String? dueDate;
  final String? dueTime;
  final String? priority;
  final String? assignedTo;

  @override
  List<Object?> get props => [
    title,
    subtitle,
    section,
    badges,
    dueDate,
    dueTime,
    priority,
    assignedTo,
  ];
}

class ResetCreateTodoForm extends CreateTodoEvent {
  const ResetCreateTodoForm();
}
