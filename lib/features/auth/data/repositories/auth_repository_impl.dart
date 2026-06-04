import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_mapper.dart';
import 'auth_local_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localRepository,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalRepository localRepository;
  final NetworkInfo networkInfo;

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.login(
          email: email,
          password: password,
        );
        final response = remote.toEntity();
        await localRepository.cacheAuthResponse(
          response,
          password: password,
        );
        return response;
      } on NetworkException {
        return localRepository.loginOffline(email: email, password: password);
      } on TimeoutException {
        return localRepository.loginOffline(email: email, password: password);
      }
    }

    return localRepository.loginOffline(email: email, password: password);
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.register(
          email: email,
          password: password,
          name: name,
        );
        final response = remote.toEntity();
        await localRepository.cacheAuthResponse(
          response,
          password: password,
        );
        return response;
      } on NetworkException {
        return localRepository.registerOffline(
          email: email,
          password: password,
          name: name,
        );
      } on TimeoutException {
        return localRepository.registerOffline(
          email: email,
          password: password,
          name: name,
        );
      }
    }

    return localRepository.registerOffline(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
      } on AppException {
        // Clear local session even when remote logout fails.
      }
    }
    await localRepository.clearSession();
  }

  @override
  Future<AuthResponse?> getCachedSession() {
    return localRepository.getCachedSession();
  }
}
