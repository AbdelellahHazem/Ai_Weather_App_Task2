import '../../domain/entities/weather.dart';


class WeatherForecastModel extends WeatherForecast {
  WeatherForecastModel({
    required String city,
    required String country,
    required double temperature,
    required String condition,
    required String icon,
    required List<WeatherDay> forecastDays,
  }) : super(
    city: city,
    country: country,
    temperature: temperature,
    condition: condition,
    icon: icon,
    forecastDays: forecastDays,
  );

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      city: json['location']['name'],
      country: json['location']['country'],
      temperature: json['current']['temp_c'].toDouble(),
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      forecastDays: (json['forecast']['forecastday'] as List)
          .map((day) => WeatherDay(
        date: day['date'],
        maxTemp: day['day']['maxtemp_c'].toDouble(),
        minTemp: day['day']['mintemp_c'].toDouble(),
        condition: day['day']['condition']['text'],
        icon: day['day']['condition']['icon'],
        hourlyForecast: (day['hour'] as List)
            .map((hour) => WeatherHour(
          time: hour['time'],
          temp: hour['temp_c'].toDouble(),
          icon: hour['condition']['icon'],
        ))
            .toList(),
      ))
          .toList(),
    );
  }
}
