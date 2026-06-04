import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../domain/usecases/get_cached_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCachedSessionUseCase,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<SsoLoginRequested>(_onSsoLoginRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedSessionUseCase getCachedSessionUseCase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(
        userId: result.user.id,
        email: result.user.email,
        name: result.user.name,
        token: result.token,
      ));
    } on AuthLocalException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await registerUseCase(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthAuthenticated(
        userId: result.user.id,
        email: result.user.email,
        name: result.user.name,
        token: result.token,
      ));
    } on AuthLocalException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await logoutUseCase();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      emit(const AuthError(AppStrings.googleLoginNotImplemented));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSsoLoginRequested(
    SsoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      emit(const AuthError(AppStrings.ssoLoginNotImplemented));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final cachedResponse = await getCachedSessionUseCase();
      if (cachedResponse != null) {
        emit(AuthAuthenticated(
          userId: cachedResponse.user.id,
          email: cachedResponse.user.email,
          name: cachedResponse.user.name,
          token: cachedResponse.token,
        ));
        return;
      }
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
