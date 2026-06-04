import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
}

class HomeNavigateToTasksEvent extends HomeEvent {
  const HomeNavigateToTasksEvent();
}

class HomeLogoutEvent extends HomeEvent {
  const HomeLogoutEvent();
}
