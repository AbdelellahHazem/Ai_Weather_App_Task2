import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_helper.dart';

// Login dependencies
import 'features/auth/login/data/login_repository_impl.dart';
import 'features/auth/login/data/remote_data_source.dart';
import 'features/auth/login/domain/usecases/login_usecase.dart';
import 'features/auth/login/presentation/cubit/login_cubit.dart';
import 'features/auth/login/presentation/screens/login_screen.dart';

// Register dependencies
import 'features/auth/register/data/register_repository_impl.dart';
import 'features/auth/register/data/remote_data_source.dart';
import 'features/auth/register/domain/usecase/register_usecase.dart';
import 'features/auth/register/presentation/cubit/register_cubit.dart';

// Weather dependencies
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/usecases/get_weather_usecase.dart';
import 'features/weather/presentation/bloc/weather_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DioHelper.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Login Bloc
        BlocProvider(
          create: (context) => LoginCubit(
            loginUseCase: LoginUseCase(
              LoginRepositoryImpl(remoteDataSource: LoginRemoteDataSource()),
            ),
          ),
        ),

        // Register Bloc
        BlocProvider(
          create: (context) => RegisterCubit(
            registerUseCase: RegisterUseCase(
              RegisterRepositoryImpl(remoteDataSource: RegisterRemoteDataSource()),
            ),
          ),
        ),

        // Weather Bloc
        BlocProvider(
          create: (context) => WeatherCubit(
            getWeatherUseCase: GetWeatherForecast(
              WeatherRepositoryImpl(remoteDataSource: WeatherRemoteDataSourceImpl()),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather & Auth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
