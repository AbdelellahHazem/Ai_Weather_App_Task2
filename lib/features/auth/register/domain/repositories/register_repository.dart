import '../entities/register.dart';

abstract class RegisterRepository {
  Future<Register?> register(String name, String email, String phone, String password);
}
