

import '../../domain/entities/register.dart';

class RegisterModel extends Register {
  const RegisterModel({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) : super(uid: uid, name: name, email: email, phone: phone);

  factory RegisterModel.fromFirebase(Map<String, dynamic> json) {
    return RegisterModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
