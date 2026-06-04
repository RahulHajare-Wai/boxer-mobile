import 'package:boxer_mobile/core/security/password_hasher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordHasher', () {
    test('hash is deterministic for same password and salt', () {
      final first = PasswordHasher.hash('secret', 'user@mail.com');
      final second = PasswordHasher.hash('secret', 'user@mail.com');
      expect(first, second);
    });

    test('verify succeeds for matching password', () {
      const password = 'secret';
      const salt = 'user@mail.com';
      final hash = PasswordHasher.hash(password, salt);
      expect(
        PasswordHasher.verify(password: password, salt: salt, storedHash: hash),
        isTrue,
      );
    });

    test('verify fails for wrong password', () {
      final hash = PasswordHasher.hash('secret', 'user@mail.com');
      expect(
        PasswordHasher.verify(
          password: 'wrong',
          salt: 'user@mail.com',
          storedHash: hash,
        ),
        isFalse,
      );
    });
  });
}
