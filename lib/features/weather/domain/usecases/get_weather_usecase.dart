import '../entities/weather.dart';
import '../repositories/weather_repository.dart';


class GetWeatherForecast {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  Future<WeatherForecast> call(String city, int days) {
    return repository.getWeatherForecast(city, days);
  }
}
