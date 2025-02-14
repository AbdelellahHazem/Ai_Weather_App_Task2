
import '../../domain/entities/register.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Register? admin;
  RegisterSuccess(this.admin);
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
