import 'user.dart';

class AuthResponse {
  const AuthResponse({required this.user, required this.token});

  final User user;
  final String token;
}