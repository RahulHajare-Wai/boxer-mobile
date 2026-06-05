import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'auth_local_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localRepository,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalRepository localRepository;

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return localRepository.loginOffline(email: email, password: password);
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) {
    return localRepository.registerOffline(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> logout() {
    return localRepository.clearSession();
  }

  @override
  Future<AuthResponse?> getCachedSession() {
    return localRepository.getCachedSession();
  }
}
