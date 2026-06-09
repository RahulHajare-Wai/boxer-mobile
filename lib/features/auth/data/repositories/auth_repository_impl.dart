import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) {
    return remoteDataSource.register(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<AuthResponse?> getCachedSession() {
    return remoteDataSource.getCachedSession();
  }
}
