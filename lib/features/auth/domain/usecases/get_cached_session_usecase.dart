import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class GetCachedSessionUseCase {
  const GetCachedSessionUseCase(this.repository);

  final AuthRepository repository;

  Future<AuthResponse?> call() {
    return repository.getCachedSession();
  }
}
