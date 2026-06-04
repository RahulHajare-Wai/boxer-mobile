import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  Future<AuthResponse> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}