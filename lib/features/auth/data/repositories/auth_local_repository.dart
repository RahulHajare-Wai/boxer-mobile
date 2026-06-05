import 'package:drift/drift.dart';

import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_local_database.dart';

/// Offline auth business logic backed by local Drift storage.
class AuthLocalRepository {
  AuthLocalRepository({required this.localDataSource, required this.database});

  final AuthLocalDataSource localDataSource;
  final AuthLocalDatabase database;

  Future<AuthResponse?> getCachedSession() async {
    final token = await localDataSource.getToken();
    if (token == null) return null;

    final authUser = await database.getUserByToken(token);
    if (authUser == null) return null;

    return AuthResponse(
      token: authUser.token,
      user: User(id: authUser.id, email: authUser.email, name: authUser.name),
    );
  }

  Future<bool> isUserLoggedIn() async {
    return (await getCachedSession()) != null;
  }

  Future<void> clearSession() async {
    await localDataSource.clearToken();
  }

  Future<AuthResponse> loginOffline({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    // ignore: avoid_print
    print(
      '[AUTH] Login attempt - Email: $normalizedEmail, Password length: ${password.length}',
    );
    final authUser = await database.getUserByEmail(normalizedEmail);
    // ignore: avoid_print
    print('[AUTH] User found in DB: ${authUser != null}');
    if (authUser != null) {
      // ignore: avoid_print
      print(
        '[AUTH] Stored password: ${authUser.password}, Provided password: $password',
      );
      // ignore: avoid_print
      print('[AUTH] Password match: ${authUser.password == password}');
    }
    if (authUser == null || authUser.password != password) {
      throw const AuthLocalException('Invalid email or password');
    }
    // ignore: avoid_print
    print('[AUTH] Login successful for user: ${authUser.email}');

    final token =
        'offline_token_${authUser.id}_${DateTime.now().millisecondsSinceEpoch}';

    await database.insertOrUpdateAuthUser(
      AuthUsersCompanion(
        id: Value(authUser.id),
        email: Value(authUser.email),
        name: Value(authUser.name),
        password: Value(authUser.password),
        token: Value(token),
      ),
    );
    await localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: User(id: authUser.id, email: authUser.email, name: authUser.name),
    );
  }

  Future<AuthResponse> registerOffline({
    required String email,
    required String password,
    required String name,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    // ignore: avoid_print
    print(
      '[AUTH] Register attempt - Email: $normalizedEmail, Name: $name, Password length: ${password.length}',
    );
    if (await isEmailRegistered(normalizedEmail)) {
      // ignore: avoid_print
      print('[AUTH] Email already registered: $normalizedEmail');
      throw const AuthLocalException('Email is already registered');
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final token = 'offline_token_$userId';
    // ignore: avoid_print
    print('[AUTH] New user ID: $userId, Token: $token');

    await database.insertOrUpdateAuthUser(
      AuthUsersCompanion(
        id: Value(userId),
        email: Value(normalizedEmail),
        name: Value(name),
        password: Value(password),
        token: Value(token),
      ),
    );
    await localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: User(id: userId, email: normalizedEmail, name: name),
    );
  }

  Future<bool> isEmailRegistered(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = await database.getUserByEmail(normalizedEmail);
    return user != null;
  }
}

class AuthLocalException implements Exception {
  const AuthLocalException(this.message);

  final String message;

  @override
  String toString() => message;
}
