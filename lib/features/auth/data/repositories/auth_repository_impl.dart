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
  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await remoteDataSource.login(email: email, password: password);
    await localDataSource.cacheToken(response.token);
    return response;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearToken();
  }

  @override
  Future<AuthResponse> register({required String email, required String password, required String name}) async {
    final response = await remoteDataSource.register(email: email, password: password, name: name);
    await localDataSource.cacheToken(response.token);
    return response;
  }
}