import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/repositories/auth_local_repository.dart';
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
    required this.authLocalRepository,
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
  final AuthLocalRepository authLocalRepository;

  /// Handle login event - uses offline repository
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Use offline login
      final result = await authLocalRepository.loginUserOffline(
        email: event.email,
        password: event.password,
      );

      if (result != null) {
        emit(AuthAuthenticated(
          userId: result.user.id,
          email: result.user.email,
          name: result.user.name,
          token: result.token,
        ));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handle registration event - uses offline repository
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Check if email already exists
      final emailExists = await authLocalRepository.isEmailRegistered(event.email);
      if (emailExists) {
        emit(const AuthError('Email is already registered'));
        return;
      }

      // Register user offline
      final result = await authLocalRepository.registerUserOffline(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (result != null) {
        emit(AuthAuthenticated(
          userId: result.user.id,
          email: result.user.email,
          name: result.user.name,
          token: result.token,
        ));
      } else {
        emit(const AuthError('Registration failed. Please try again.'));
      }
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
      await authLocalRepository.clearAuthData();
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

  /// Handle auth check event (useful for checking existing session on app start)
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Check if user is already logged in from local storage
      final isLoggedIn = await authLocalRepository.isUserLoggedIn();
      if (isLoggedIn) {
        final cachedResponse = await authLocalRepository.getCachedAuthResponse();
        if (cachedResponse != null) {
          emit(AuthAuthenticated(
            userId: cachedResponse.user.id,
            email: cachedResponse.user.email,
            name: cachedResponse.user.name,
            token: cachedResponse.token,
          ));
          return;
        }
      }
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}