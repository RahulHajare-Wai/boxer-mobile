import 'package:drift/drift.dart';

class AuthUsers extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();
  TextColumn get password => text()();
  TextColumn get token => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class AuthSessions extends Table {
  TextColumn get id => text()();
  TextColumn get accessToken => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
