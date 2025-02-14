import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/login/data/login_repository_impl.dart';
import 'features/auth/login/data/remote_data_source.dart';
import 'features/auth/login/domain/usecases/login_usecase.dart';
import 'features/auth/login/presentation/cubit/login_cubit.dart';
import 'features/auth/login/presentation/screens/login_screen.dart';
import 'features/auth/register/data/register_repository_impl.dart';
import 'features/auth/register/data/remote_data_source.dart';
import 'features/auth/register/domain/usecase/register_usecase.dart';
import 'features/auth/register/presentation/cubit/register_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Data Sources
  final loginRemoteDataSource = LoginRemoteDataSource();
  final registerRemoteDataSource = RegisterRemoteDataSource();

  // Initialize Repositories
  final LoginRepository = LoginRepositoryImpl(remoteDataSource: loginRemoteDataSource);
  final RegisterRepository = RegisterRepositoryImpl(remoteDataSource: registerRemoteDataSource);

  // Initialize Use Cases
  final adminLoginUseCase = LoginUseCase(LoginRepository);
  final adminRegisterUseCase = RegisterUseCase(RegisterRepository);

  runApp(MyApp(
    adminLoginUseCase: adminLoginUseCase,
    adminRegisterUseCase: adminRegisterUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase adminLoginUseCase;
  final RegisterUseCase adminRegisterUseCase;

  const MyApp({
    Key? key,
    required this.adminLoginUseCase,
    required this.adminRegisterUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(loginUseCase: adminLoginUseCase),
        ),
        BlocProvider(
         create: (context) => RegisterCubit(registerUseCase: adminRegisterUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

