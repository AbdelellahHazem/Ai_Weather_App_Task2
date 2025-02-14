

import '../../domain/entities/login.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Login? admin;
  LoginSuccess(this.admin);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
