import '../../domain/entities/weather.dart';

class WeatherModel {
  final String cityName;
  final String outlook;
  final String temperature;
  final String humidity;

  WeatherModel({
    required this.cityName,
    required this.outlook,
    required this.temperature,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      outlook: json['current']['condition']['text'].toLowerCase().contains("rain") ? "rainy" : "sunny",
      temperature: (json['current']['temp_c'] as num).toDouble() > 25 ? "hot" : "mild",
      humidity: (json['current']['humidity'] as num).toDouble() < 60 ? "normal" : "high",
    );
  }
}

class WeatherForecastModel extends WeatherForecast {
  final WeatherModel currentWeather;

  WeatherForecastModel({
    required String cityName,
    required String country,
    required double temperature,
    required String condition,
    required String icon,
    required List<WeatherDay> forecastDays,
    required this.currentWeather,
  }) : super(
    cityName: cityName,
    country: country,
    temperature: temperature,
    condition: condition,
    icon: icon,
    forecastDays: forecastDays,
  );

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      icon: "https:${json['current']['condition']['icon']}",
      forecastDays: (json['forecast']['forecastday'] as List)
          .map((day) => WeatherDay.fromJson(day))
          .toList(),
      currentWeather: WeatherModel.fromJson(json),
    );
  }
}
