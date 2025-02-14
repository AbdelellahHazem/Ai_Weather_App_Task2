import '../../domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required String uid,
    required String email,
  }) : super(uid: uid, email: email);

  factory LoginModel.fromFirebase(Map<String, dynamic> json) {
    return LoginModel(
      uid: json['uid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
