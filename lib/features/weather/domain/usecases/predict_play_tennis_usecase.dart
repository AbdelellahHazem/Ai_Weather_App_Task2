import '../entities/weather.dart';

class PredictPlayTennisUseCase {
  List<int> convertWeatherToModelInput(WeatherForecast weather) {
    return [
      weather.condition.toLowerCase().contains("rain") ? 1 : 0,  // Outlook: Rainy
      weather.condition.toLowerCase().contains("sun") ? 1 : 0,   // Outlook: Sunny
      weather.temperature > 25 ? 1 : 0, // Temperature: Hot
      (weather.temperature > 15 && weather.temperature <= 25) ? 1 : 0, // Temperature: Mild
      weather.condition.toLowerCase().contains("dry") ? 1 : 0,   // Humidity: Normal
    ];
  }
}
