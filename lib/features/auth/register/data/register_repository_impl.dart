
import 'package:weather_ai_app/features/auth/register/data/remote_data_source.dart';

import '../domain/entities/register.dart';
import '../domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Register?> register(String name, String email, String phone, String password) async {
    final user = await remoteDataSource.register(name, email, phone, password);
    if (user != null) {
      return Register(uid: user.uid, name: name, email: email, phone: phone);
    }
    return null;
  }
}
