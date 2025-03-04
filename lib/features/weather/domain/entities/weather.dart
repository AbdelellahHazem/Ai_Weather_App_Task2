class WeatherForecast {
  final String cityName;
  final String country;
  final double temperature;
  final String condition;
  final String icon;
  final List<WeatherDay> forecastDays;

  WeatherForecast({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.forecastDays,
  });
}

class WeatherDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final List<WeatherHour> hourlyForecast;

  WeatherDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.hourlyForecast,
  });

  factory WeatherDay.fromJson(Map<String, dynamic> json) {
    return WeatherDay(
      date: json['date'],
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'],
      icon: "https:${json['day']['condition']['icon']}",
      hourlyForecast: (json['hour'] as List)
          .map((hour) => WeatherHour.fromJson(hour))
          .toList(),
    );
  }
}

class WeatherHour {
  final String time;
  final double temp;
  final String icon;

  WeatherHour({
    required this.time,
    required this.temp,
    required this.icon,
  });

  factory WeatherHour.fromJson(Map<String, dynamic> json) {
    return WeatherHour(
      time: json['time'],
      temp: (json['temp_c'] as num).toDouble(),
      icon: "https:${json['condition']['icon']}",
    );
  }
}
