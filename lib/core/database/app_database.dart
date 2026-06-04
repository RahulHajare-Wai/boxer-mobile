import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/auth_user_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AuthUsers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Insert or update an auth user
  Future<int> insertOrUpdateAuthUser(AuthUsersCompanion user) async {
    return into(authUsers).insertOnConflictUpdate(user);
  }

  /// Get the currently logged-in user
  Future<AuthUser?> getCurrentUser() async {
    return await select(authUsers).getSingleOrNull();
  }

  /// Get user by ID
  Future<AuthUser?> getUserById(String userId) async {
    return await (select(authUsers)..where((u) => u.id.equals(userId))).getSingleOrNull();
  }

  /// Get user by email
  Future<AuthUser?> getUserByEmail(String email) async {
    return await (select(authUsers)..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  /// Delete all auth users (logout)
  Future<int> deleteAllAuthUsers() async {
    return delete(authUsers).go();
  }

  /// Delete user by ID
  Future<int> deleteUserById(String userId) async {
    return (delete(authUsers)..where((u) => u.id.equals(userId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
