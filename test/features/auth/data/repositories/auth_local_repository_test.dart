import 'package:flutter_test/flutter_test.dart';

import 'package:boxer_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:boxer_mobile/features/auth/data/models/auth_local_database.dart';
import 'package:boxer_mobile/features/auth/data/repositories/auth_local_repository.dart';

void main() {
  late AuthLocalDatabase database;
  late AuthLocalRepository repository;

  setUp(() async {
    database = AuthLocalDatabase();
    repository = AuthLocalRepository(
      localDataSource: AuthLocalDataSourceImpl(database: database),
      database: database,
    );

    await database.deleteAllAuthUsers();
    await database.clearToken();
  });

  tearDown(() async {
    await database.deleteAllAuthUsers();
    await database.clearToken();
    await database.close();
  });

  test(
    'registers user offline and allows later login with same credentials',
    () async {
      const email = 'offline.user@boxer.com';
      const password = 'Password@123';
      const name = 'Offline User';

      final registeredUser = await repository.registerOffline(
        email: email,
        password: password,
        name: name,
      );

      expect(registeredUser.user.email, email);
      expect(registeredUser.user.name, name);

      await repository.clearSession();

      final cachedSessionAfterLogout = await repository.getCachedSession();
      expect(cachedSessionAfterLogout, isNull);

      final loggedInUser = await repository.loginOffline(
        email: email,
        password: password,
      );

      expect(loggedInUser.user.email, email);
      expect(loggedInUser.user.name, name);

      final cachedSessionAfterLogin = await repository.getCachedSession();
      expect(cachedSessionAfterLogin, isNotNull);
      expect(cachedSessionAfterLogin?.user.email, email);
    },
  );
}
