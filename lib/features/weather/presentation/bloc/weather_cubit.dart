import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather_usecase.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/endpoints.dart';

// 🔹 Weather States
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherForecast weather;
  WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError({required this.message});
}

// 🔹 Tennis Prediction States (Merged into WeatherState for Simplicity)
class TennisPredictionLoading extends WeatherState {}

class TennisPredictionLoaded extends WeatherState {
  final int prediction;
  TennisPredictionLoaded({required this.prediction});
}

class TennisPredictionError extends WeatherState {
  final String message;
  TennisPredictionError({required this.message});
}

// 🌦️ Weather Cubit
class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherForecast getWeatherUseCase;

  WeatherCubit({required this.getWeatherUseCase}) : super(WeatherInitial());

  // 📌 Fetch Weather Data
  Future<void> fetchWeather(String city, int days) async {
    emit(WeatherLoading());
    try {
      final weather = await getWeatherUseCase(city, days);
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: "Failed to fetch weather: ${e.toString()}"));
    }
  }

  // 🎾 Predict Tennis Playability
  Future<void> predictPlayTennis(List<int> modelInput) async {
    emit(TennisPredictionLoading());
    try {
      final response = await DioHelper.postData(
        url: Endpoints.predict,
        data: {"features": modelInput},
      );

      if (response != null && response.data != null && response.data.containsKey("prediction")) {
        final predictionData = response.data["prediction"];

        // ✅ Handle List or Single Value
        int prediction;
        if (predictionData is List && predictionData.isNotEmpty) {
          prediction = predictionData.first as int; // Get first element
        } else if (predictionData is int) {
          prediction = predictionData;
        } else {
          throw Exception("Unexpected response format: $predictionData");
        }

        emit(TennisPredictionLoaded(prediction: prediction));
      } else {
        emit(TennisPredictionError(message: "Invalid response from server"));
      }
    } catch (e) {
      emit(TennisPredictionError(message: "Failed to get prediction: ${e.toString()}"));
    }
  }
}
