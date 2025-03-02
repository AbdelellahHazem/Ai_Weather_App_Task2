import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeatherForecast(String city, int days);
}
