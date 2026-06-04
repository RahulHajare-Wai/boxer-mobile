import 'package:drift/drift.dart';
import 'package:boxer_mobile/core/database/app_database.dart';

import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_local_datasource.dart';

/// Repository for handling offline/local auth data using Drift
class AuthLocalRepository {
  final AppDatabase database;
  final AuthLocalDataSource localDataSource;

  AuthLocalRepository({
    required this.database,
    required this.localDataSource,
  });

  /// Save auth response locally
  /// Stores both the token in SharedPreferences and user data in Drift
  Future<void> saveAuthResponse(AuthResponse authResponse) async {
    // Save token in SharedPreferences for quick access
    await localDataSource.cacheToken(authResponse.token);

    // Save user data in Drift database
    final authUserCompanion = AuthUsersCompanion(
      id: Value(authResponse.user.id),
      email: Value(authResponse.user.email),
      name: Value(authResponse.user.name),
      token: Value(authResponse.token),
    );

    await database.insertOrUpdateAuthUser(authUserCompanion);
  }

  /// Get cached auth response from local storage
  /// Returns null if user is not logged in
  Future<AuthResponse?> getCachedAuthResponse() async {
    final token = await localDataSource.getToken();
    if (token == null) return null;

    final authUser = await database.getCurrentUser();
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

  /// Get cached user from local storage
  /// Returns null if user is not found
  Future<User?> getCachedUser() async {
    final authUser = await database.getCurrentUser();
    if (authUser == null) return null;

    return User(
      id: authUser.id,
      email: authUser.email,
      name: authUser.name,
    );
  }

  /// Get user by ID from local storage
  Future<User?> getUserById(String userId) async {
    final authUser = await database.getUserById(userId);
    if (authUser == null) return null;

    return User(
      id: authUser.id,
      email: authUser.email,
      name: authUser.name,
    );
  }

  /// Get user by email from local storage
  Future<User?> getUserByEmail(String email) async {
    final authUser = await database.getUserByEmail(email);
    if (authUser == null) return null;

    return User(
      id: authUser.id,
      email: authUser.email,
      name: authUser.name,
    );
  }

  /// Get cached token
  Future<String?> getCachedToken() async {
    return await localDataSource.getToken();
  }

  /// Check if user is logged in (has cached data)
  Future<bool> isUserLoggedIn() async {
    final token = await localDataSource.getToken();
    if (token == null) return false;

    final user = await database.getCurrentUser();
    return user != null;
  }

  /// Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await localDataSource.clearToken();
    await database.deleteAllAuthUsers();
  }

  /// Clear user by ID
  Future<void> clearUserById(String userId) async {
    await database.deleteUserById(userId);
  }

  /// Update cached user data
  Future<void> updateCachedUser(User user) async {
    final token = await localDataSource.getToken();
    if (token == null) return;

    final authUserCompanion = AuthUsersCompanion(
      id: Value(user.id),
      email: Value(user.email),
      name: Value(user.name),
      token: Value(token),
    );

    await database.insertOrUpdateAuthUser(authUserCompanion);
  }

  /// Get all cached users
  Future<List<User>> getAllCachedUsers() async {
    final authUsers = await database.authUsers.select().get();
    return authUsers
        .map(
          (authUser) => User(
            id: authUser.id,
            email: authUser.email,
            name: authUser.name,
          ),
        )
        .toList();
  }

  /// Register a new user offline
  /// Returns AuthResponse if successful, null if email already exists
  Future<AuthResponse?> registerUserOffline({
    required String email,
    required String password,
    required String name,
  }) async {
    // Check if user already exists
    final existingUser = await database.getUserByEmail(email);
    if (existingUser != null) {
      return null; // Email already registered
    }

    // Generate a unique ID and token for the new user
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final token = 'offline_token_$userId';

    // Create the user in the database
    final authUserCompanion = AuthUsersCompanion(
      id: Value(userId),
      email: Value(email),
      name: Value(name),
      password: Value(password),
      token: Value(token),
    );

    await database.insertOrUpdateAuthUser(authUserCompanion);

    // Cache the token
    await localDataSource.cacheToken(token);

    return AuthResponse(
      token: token,
      user: User(
        id: userId,
        email: email,
        name: name,
      ),
    );
  }

  /// Login user offline using stored credentials
  /// Returns AuthResponse if credentials match, null if invalid
  Future<AuthResponse?> loginUserOffline({
    required String email,
    required String password,
  }) async {
    // Find user by email
    final authUser = await database.getUserByEmail(email);
    if (authUser == null) {
      return null; // User not found
    }

    // Verify password
    if (authUser.password != password) {
      return null; // Invalid password
    }

    // Update token and cache it
    final newToken = 'offline_token_${authUser.id}_${DateTime.now().millisecondsSinceEpoch}';
    
    final updatedUserCompanion = AuthUsersCompanion(
      id: Value(authUser.id),
      email: Value(authUser.email),
      name: Value(authUser.name),
      password: Value(authUser.password),
      token: Value(newToken),
    );

    await database.insertOrUpdateAuthUser(updatedUserCompanion);
    await localDataSource.cacheToken(newToken);

    return AuthResponse(
      token: newToken,
      user: User(
        id: authUser.id,
        email: authUser.email,
        name: authUser.name,
      ),
    );
  }

  /// Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    final user = await database.getUserByEmail(email);
    return user != null;
  }
}
