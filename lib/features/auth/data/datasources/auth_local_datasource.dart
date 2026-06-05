import '../models/auth_local_database.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required this.database});

  final AuthLocalDatabase database;

  @override
  Future<void> cacheToken(String token) {
    return database.cacheToken(token);
  }

  @override
  Future<String?> getToken() {
    return database.getToken();
  }

  @override
  Future<void> clearToken() {
    return database.clearToken();
  }
}
