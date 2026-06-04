import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return localDataSource.loginOffline(email: email, password: password);
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) {
    return localDataSource.registerOffline(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearSession();
  }

  @override
  Future<AuthResponse?> getCachedSession() {
    return localDataSource.getCachedSession();
  }
}
