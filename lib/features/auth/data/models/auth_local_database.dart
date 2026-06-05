import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'auth_user_table.dart';

part 'auth_local_database.g.dart';

const _sessionId = 'current';

@DriftDatabase(tables: [AuthUsers, AuthSessions])
class AuthLocalDatabase extends _$AuthLocalDatabase {
  AuthLocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertOrUpdateAuthUser(AuthUsersCompanion user) {
    return into(authUsers).insertOnConflictUpdate(user);
  }

  Future<AuthUser?> getCurrentUser() {
    return select(authUsers).getSingleOrNull();
  }

  Future<AuthUser?> getUserByToken(String token) {
    return (select(
      authUsers,
    )..where((u) => u.token.equals(token))).getSingleOrNull();
  }

  Future<AuthUser?> getUserByEmail(String email) {
    return (select(
      authUsers,
    )..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<int> deleteAllAuthUsers() {
    return delete(authUsers).go();
  }

  Future<void> cacheToken(String token) async {
    await into(authSessions).insertOnConflictUpdate(
      AuthSessionsCompanion(
        id: const Value(_sessionId),
        accessToken: Value(token),
      ),
    );
  }

  Future<String?> getToken() async {
    final session = await (select(
      authSessions,
    )..where((s) => s.id.equals(_sessionId))).getSingleOrNull();
    return session?.accessToken;
  }

  Future<void> clearToken() async {
    await (delete(authSessions)..where((s) => s.id.equals(_sessionId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = Directory('${Directory.systemTemp.path}/boxer_mobile');
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }
    final file = File('${dbFolder.path}/auth.db');
    return NativeDatabase(file);
  });
}
