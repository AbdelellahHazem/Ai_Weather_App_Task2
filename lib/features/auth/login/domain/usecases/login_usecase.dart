import '../entities/login.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<Login?> call(String email, String password) {
    return repository.login(email, password);
  }
}
