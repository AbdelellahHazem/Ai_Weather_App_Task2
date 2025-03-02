import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import '../bloc/weather_cubit.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();
  int selectedDays = 3;
  String currentCity = "Search for a city";

  @override
  Widget build(BuildContext context) {
    // Get device width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          currentCity,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05, // Responsive font size
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter city name...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() => currentCity = value);
                  context.read<WeatherCubit>().fetchWeather(value, selectedDays);
                }
                _searchController.clear();
              },
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // 🌤 Weather Data Display
            Expanded(
              child: BlocBuilder<WeatherCubit, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return _buildWeatherContent(state.weather, screenWidth, screenHeight);
                  } else if (state is WeatherError) {
                    return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ));
                  }
                  return const Center(
                      child: Text("Search for a city to get weather data.", style: TextStyle(color: Colors.white)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌤 Build Weather Content
  Widget _buildWeatherContent(WeatherForecast weather, double screenWidth, double screenHeight) {
    return ListView(
      children: [
        // Current Weather Card
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white.withOpacity(0.15),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              children: [
                Image.network(
                  "https:${weather.icon}",
                  width: screenWidth * 0.25, // Responsive width
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_off, size: 60, color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "${weather.temperature}°C",
                  style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(weather.condition, style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white70)),
              ],
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        // 📅 3-Day Forecast Title
        Text(
          "3-Day Forecast",
          style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: screenHeight * 0.01),

        // Forecast List
        Column(
          children: weather.forecastDays.map((day) => _buildForecastDay(day, screenWidth, screenHeight)).toList(),
        ),
      ],
    );
  }

  // 📅 Build Forecast Day Card
  Widget _buildForecastDay(WeatherDay day, double screenWidth, double screenHeight) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.2),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              "https:${day.icon}",
              width: screenWidth * 0.15,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_off, size: 40, color: Colors.white),
            ),
            title: Text(
              DateFormat('EEEE, MMM d').format(DateTime.parse(day.date)),
              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              "Max: ${day.maxTemp}°C | Min: ${day.minTemp}°C",
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
            ),
          ),

          // 🌡️ Expandable Hourly Forecast
          ExpansionTile(
            title: Text("Hourly Forecast", style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
            children: day.hourlyForecast.map((hour) => _buildHourlyForecast(hour, screenWidth)).toList(),
          ),
        ],
      ),
    );
  }

  // ⏳ Build Hourly Forecast Row
  Widget _buildHourlyForecast(WeatherHour hour, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('h a').format(DateTime.parse(hour.time)),
            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
          ),
          Image.network(
            "https:${hour.icon}",
            width: screenWidth * 0.1,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_off, size: 30, color: Colors.white),
          ),
          Text(
            "${hour.temp}°C",
            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
