

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_ai_app/features/auth/register/presentation/cubit/register_state.dart';

import '../../domain/usecase/register_usecase.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(String name, String email, String phone, String password) async {
    emit(RegisterLoading());
    try {
      final admin = await registerUseCase(name, email, phone, password);
      emit(RegisterSuccess(admin));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
