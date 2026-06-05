import 'package:drift/drift.dart';

import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_local_database.dart';

/// Offline auth business logic backed by local Drift storage.
class AuthLocalRepository {
  AuthLocalRepository({
    required AuthLocalDataSource localDataSource,
    required AuthLocalDatabase database,
  })  : _localDataSource = localDataSource,
        _database = database;

  final AuthLocalDataSource _localDataSource;
  final AuthLocalDatabase _database;

  Future<AuthResponse?> getCachedSession() async {
    final token = await _localDataSource.getToken();
    if (token == null) return null;

    final authUser = await _database.getCurrentUser();
    if (authUser == null) return null;

    return AuthResponse(
      token: authUser.token,
      user: User(
        id: authUser.id,
        email: authUser.email,
        name: authUser.name,
      ),
    );
  }

  Future<bool> isUserLoggedIn() async {
    return (await getCachedSession()) != null;
  }

  Future<void> clearSession() async {
    await _localDataSource.clearToken();
    await _database.deleteAllAuthUsers();
  }

  Future<AuthResponse> loginOffline({
    required String email,
    required String password,
  }) async {
    final authUser = await _database.getUserByEmail(email);
    if (authUser == null || authUser.password != password) {
      throw const AuthLocalException('Invalid email or password');
    }

    final token =
        'offline_token_${authUser.id}_${DateTime.now().millisecondsSinceEpoch}';

    await _database.insertOrUpdateAuthUser(
      AuthUsersCompanion(
        id: Value(authUser.id),
        email: Value(authUser.email),
        name: Value(authUser.name),
        password: Value(authUser.password),
        token: Value(token),
      ),
    );
    await _localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: User(
        id: authUser.id,
        email: authUser.email,
        name: authUser.name,
      ),
    );
  }

  Future<AuthResponse> registerOffline({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await isEmailRegistered(email)) {
      throw const AuthLocalException('Email is already registered');
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final token = 'offline_token_$userId';

    await _database.insertOrUpdateAuthUser(
      AuthUsersCompanion(
        id: Value(userId),
        email: Value(email),
        name: Value(name),
        password: Value(password),
        token: Value(token),
      ),
    );
    await _localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: User(id: userId, email: email, name: name),
    );
  }

  Future<bool> isEmailRegistered(String email) async {
    final user = await _database.getUserByEmail(email);
    return user != null;
  }
}

class AuthLocalException implements Exception {
  const AuthLocalException(this.message);

  final String message;

  @override
  String toString() => message;
}
