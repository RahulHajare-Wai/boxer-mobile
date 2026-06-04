import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../database/auth_database.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<AuthResponse?> getCachedSession();
  Future<bool> isUserLoggedIn();
  Future<void> clearSession();

  Future<AuthResponse> loginOffline({
    required String email,
    required String password,
  });

  Future<AuthResponse> registerOffline({
    required String email,
    required String password,
    required String name,
  });

  Future<bool> isEmailRegistered(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required SharedPreferences prefs,
    required AuthDatabase database,
  })  : _prefs = prefs,
        _database = database;

  final SharedPreferences _prefs;
  final AuthDatabase _database;

  @override
  Future<void> cacheToken(String token) async {
    await _prefs.setString(AppConstants.keyAccessToken, token);
    await _prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(AppConstants.keyAccessToken);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.keyAccessToken);
    await _prefs.setBool(AppConstants.keyIsLoggedIn, false);
  }

  @override
  Future<AuthResponse?> getCachedSession() async {
    final token = await getToken();
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

  @override
  Future<bool> isUserLoggedIn() async {
    if (!(_prefs.getBool(AppConstants.keyIsLoggedIn) ?? false)) {
      return false;
    }
    return (await getCachedSession()) != null;
  }

  @override
  Future<void> clearSession() async {
    await clearToken();
    await _database.deleteAllAuthUsers();
    await _prefs.remove(AppConstants.keyUserId);
  }

  @override
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
    await cacheToken(token);

    final user = User(
      id: authUser.id,
      email: authUser.email,
      name: authUser.name,
    );
    return AuthResponse(token: token, user: user);
  }

  @override
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
    await cacheToken(token);

    final user = User(id: userId, email: email, name: name);
    return AuthResponse(token: token, user: user);
  }

  @override
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
