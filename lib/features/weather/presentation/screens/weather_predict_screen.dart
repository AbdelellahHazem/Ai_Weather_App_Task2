import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_cubit.dart';
import '../bloc/weather_state.dart';
import '../../domain/usecases/predict_play_tennis_usecase.dart';
import '../../domain/entities/weather.dart';

class WeatherPredictionScreen extends StatefulWidget {
  const WeatherPredictionScreen({super.key});

  @override
  State<WeatherPredictionScreen> createState() => _WeatherPredictionScreenState();
}

class _WeatherPredictionScreenState extends State<WeatherPredictionScreen> {
  final TextEditingController _cityController = TextEditingController();
  int selectedDays = 3;
  Color? backgroundColor = Colors.blueGrey[900]; // Default Background Color

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor!, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 🔍 Search Bar
              TextField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter city name...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _fetchWeather(context),
                  ),
                ),
                onSubmitted: (value) => _fetchWeather(context),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 🌤 Weather & Prediction Display
              Expanded(
                child: BlocConsumer<WeatherCubit, WeatherState>(
                  listener: (context, state) {
                    if (state is WeatherLoaded) {
                      _updateBackgroundColor(state.weather.condition);
                    } else if (state is TennisPredictionLoaded) {
                      _showPredictionDialog(context, state.prediction);
                    } else if (state is TennisPredictionError) {
                      _showErrorDialog(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is WeatherLoading || state is TennisPredictionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WeatherLoaded) {
                      return _buildWeatherCard(state.weather, screenWidth, screenHeight);
                    }
                    if (state is WeatherError) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        "Enter a city to get weather prediction.",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🌤 Fetch Weather Data
  void _fetchWeather(BuildContext context) {
    if (_cityController.text.isNotEmpty) {
      context.read<WeatherCubit>().fetchWeather(_cityController.text, selectedDays);
    }
  }

  // 🎨 Update Background Color Based on Weather
  void _updateBackgroundColor(String condition) {
    setState(() {
      if (condition.toLowerCase().contains("rain")) {
        backgroundColor = Colors.blueAccent; // 🌧️ Rainy
      } else if (condition.toLowerCase().contains("sunny")) {
        backgroundColor = Colors.orangeAccent; // ☀️ Sunny
      } else if (condition.toLowerCase().contains("cloud")) {
        backgroundColor = Colors.grey; // ☁️ Cloudy
      } else {
        backgroundColor = Colors.blueGrey[900]!; // Default
      }
    });
  }

  // 🃏 Build Weather Card
  Widget _buildWeatherCard(WeatherForecast weather, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white.withOpacity(0.2), // 🌟 Glassmorphism Effect
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(
                    weather.icon.startsWith("http") ? weather.icon : "https:${weather.icon}",
                    key: ValueKey(weather.icon),
                    width: screenWidth * 0.2,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.cloud_off, size: 60, color: Colors.white),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "${weather.temperature}°C",
                  style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  weather.condition,
                  style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

        // 🎾 Predict Tennis Playability Button
        ElevatedButton(
          onPressed: () => _predictTennis(context, weather),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15, vertical: screenHeight * 0.02),
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            "Will I Go Outside?",
            style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 🎾 Convert Weather to Model Input & Predict
  void _predictTennis(BuildContext context, WeatherForecast weather) {
    final modelInput = PredictPlayTennisUseCase().convertWeatherToModelInput(weather);
    context.read<WeatherCubit>().predictPlayTennis(modelInput);
  }

  // 🎾 Show Prediction Result
  void _showPredictionDialog(BuildContext context, dynamic prediction) {
    String message = prediction == 1
        ? "Weather looks great! Go outside and have fun!"
        : "Not the best weather for outdoor activities. Stay inside! ⛅";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(prediction == 1 ? "✅ Go Outside!" : "❌ Stay Inside"),
          content: Text(message),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // ❌ Show Error Dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
