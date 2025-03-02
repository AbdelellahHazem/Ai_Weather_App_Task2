
import '../entities/register.dart';
import '../repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase(this.repository);

  Future<Register?> call(String name, String email, String phone, String password) {
    return repository.register(name, email, phone, password);
  }
}
