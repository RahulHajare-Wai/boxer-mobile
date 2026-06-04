import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<HomeNavigateToTasksEvent>(_onNavigateToTasks);
    on<HomeLogoutEvent>(_onLogout);
  }

  Future<void> _onHomeInitial(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());
      // TODO: Add any initialization logic here
      emit(const HomeLoaded());
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onNavigateToTasks(
    HomeNavigateToTasksEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoaded());
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    HomeLogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoaded());
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
