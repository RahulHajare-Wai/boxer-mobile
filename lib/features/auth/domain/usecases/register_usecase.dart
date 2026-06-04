import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this.repository);

  final AuthRepository repository;

  Future<AuthResponse> call({required String email, required String password, required String name}) {
    return repository.register(email: email, password: password, name: name);
  }
}