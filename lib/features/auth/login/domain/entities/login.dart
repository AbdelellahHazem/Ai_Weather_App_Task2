import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String uid;
  final String email;

  const Login({
    required this.uid,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, email];
}
