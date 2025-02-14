
import 'package:weather_ai_app/features/auth/login/data/remote_data_source.dart';

import '../domain/entities/login.dart';
import '../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Login?> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    if (user != null) {
      return Login(uid: user.uid, email: email);
    }
    return null;
  }
}
