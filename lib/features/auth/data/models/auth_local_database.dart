import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'auth_user_table.dart';

part 'auth_local_database.g.dart';

@DriftDatabase(tables: [AuthUsers])
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

  Future<AuthUser?> getUserByEmail(String email) {
    return (select(authUsers)..where((u) => u.email.equals(email)))
        .getSingleOrNull();
  }

  Future<int> deleteAllAuthUsers() {
    return delete(authUsers).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'auth.db'));
    return NativeDatabase(file);
  });
}
