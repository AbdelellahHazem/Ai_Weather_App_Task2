import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;

  const Register({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [uid, name, email, phone];
}
