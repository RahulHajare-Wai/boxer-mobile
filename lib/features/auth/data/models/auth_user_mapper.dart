import '../../domain/entities/user.dart';
import 'auth_local_database.dart';
import 'user_model.dart';

extension AuthUserMapper on AuthUser {
  User toUser() => UserModel(id: id, email: email, name: name);
}
