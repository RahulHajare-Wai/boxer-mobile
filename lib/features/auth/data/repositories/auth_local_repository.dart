import 'package:drift/drift.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/security/password_hasher.dart';
import '../../domain/entities/auth_response.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_local_database.dart';
import '../models/auth_user_mapper.dart';
import '../models/user_model.dart';

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

    return AuthResponse(token: authUser.token, user: authUser.toUser());
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
    if (authUser == null ||
        !PasswordHasher.verify(
          password: password,
          salt: authUser.email,
          storedHash: authUser.password,
        )) {
      throw const UnauthorizedException(message: 'Invalid email or password');
    }

    final token =
        'offline_token_${authUser.id}_${DateTime.now().millisecondsSinceEpoch}';

    await _upsertUser(
      id: authUser.id,
      email: authUser.email,
      name: authUser.name,
      passwordHash: authUser.password,
      token: token,
    );
    await _localDataSource.cacheToken(token);

    return AuthResponse(token: token, user: authUser.toUser());
  }

  Future<AuthResponse> registerOffline({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await isEmailRegistered(email)) {
      throw const ValidationException(message: 'Email is already registered');
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final token = 'offline_token_$userId';
    final passwordHash = PasswordHasher.hash(password, email);

    await _upsertUser(
      id: userId,
      email: email,
      name: name,
      passwordHash: passwordHash,
      token: token,
    );
    await _localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: UserModel(id: userId, email: email, name: name),
    );
  }

  Future<bool> isEmailRegistered(String email) async {
    final user = await _database.getUserByEmail(email);
    return user != null;
  }

  /// Persists a successful remote session for offline restore and fallback login.
  Future<void> cacheAuthResponse(
    AuthResponse response, {
    required String password,
  }) async {
    final passwordHash = PasswordHasher.hash(password, response.user.email);
    await _upsertUser(
      id: response.user.id,
      email: response.user.email,
      name: response.user.name,
      passwordHash: passwordHash,
      token: response.token,
    );
    await _localDataSource.cacheToken(response.token);
  }

  Future<void> _upsertUser({
    required String id,
    required String email,
    required String name,
    required String passwordHash,
    required String token,
  }) {
    return _database.insertOrUpdateAuthUser(
      AuthUsersCompanion(
        id: Value(id),
        email: Value(email),
        name: Value(name),
        password: Value(passwordHash),
        token: Value(token),
      ),
    );
  }
}
