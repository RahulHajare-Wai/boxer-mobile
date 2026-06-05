import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
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
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<SsoLoginRequested>(_onSsoLoginRequested);
  }

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  /// Handle login event
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
      emit(
        AuthAuthenticated(
          userId: result.user.id,
          email: result.user.email,
          name: result.user.name,
          token: result.token,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle registration event
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
      emit(
        AuthAuthenticated(
          userId: result.user.id,
          email: result.user.email,
          name: result.user.name,
          token: result.token,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle logout event
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

  /// Handle Google login event
  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // TODO: Implement Google login using Firebase or other provider
      emit(const AuthError(AppStrings.googleLoginNotImplemented));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle SSO login event
  Future<void> _onSsoLoginRequested(
    SsoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // TODO: Implement SSO login using the corporate identity provider
      emit(const AuthError(AppStrings.ssoLoginNotImplemented));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
