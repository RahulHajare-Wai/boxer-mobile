import '../models/auth_local_database.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required AuthLocalDatabase database})
      : _database = database;

  final AuthLocalDatabase _database;

  @override
  Future<void> cacheToken(String token) {
    return _database.cacheToken(token);
  }

  @override
  Future<String?> getToken() {
    return _database.getToken();
  }

  @override
  Future<void> clearToken() {
    return _database.clearToken();
  }
}
