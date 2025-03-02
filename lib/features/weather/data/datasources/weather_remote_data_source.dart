import '../models/weather_forecast_model.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/endpoints.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherForecastModel> fetchWeatherForecast(String city, int days);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  @override
  Future<WeatherForecastModel> fetchWeatherForecast(String city, int days) async {
    final response = await DioHelper.get(
      endpoint: '/forecast.json',
      params: {
        'key': Endpoints.apikey,
        'q': city,
        'days': days.toString(),
      },
    );

    if (response.statusCode == 200) {
      return WeatherForecastModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
