class WeatherForecast {
  final String city;
  final String country;
  final double temperature;
  final String condition;
  final String icon;
  final List<WeatherDay> forecastDays;

  WeatherForecast({
    required this.city,
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
}
