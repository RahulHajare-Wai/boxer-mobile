import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  PasswordHasher._();

  static String hash(String password, String salt) {
    final normalizedSalt = salt.trim().toLowerCase();
    final bytes = utf8.encode('$normalizedSalt::$password');
    return sha256.convert(bytes).toString();
  }

  static bool verify({
    required String password,
    required String salt,
    required String storedHash,
  }) {
    return hash(password, salt) == storedHash;
  }
}
