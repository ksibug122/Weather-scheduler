import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  bool isLoading = true;
  Map<String, dynamic> currentWeather = {};
  List<Map<String, dynamic>> forecastData = [];
  final double lat = 14.5995;
  final double lon = 120.9842;

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<void> fetchForecast() async {
    try {
      final weatherService = WeatherService();
      final current = await weatherService.getCurrentWeather(lat, lon);
      final forecast = await weatherService.get5DayForecast(lat, lon);
      setState(() {
        currentWeather = current;
        forecastData = forecast;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading forecast: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Icons.umbrella;
      case 'clouds':
        return Icons.cloud;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  Color getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Colors.blue;
      case 'clouds':
        return Colors.grey;
      case 'thunderstorm':
        return Colors.deepPurple;
      case 'snow':
        return Colors.lightBlueAccent;
      default:
        return Colors.orange;
    }
  }

  String getAdvisory(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return 'Rainy conditions expected. Carry an umbrella and wear waterproof clothing.';
      case 'clouds':
        return 'Cloudy skies. Good day to carry a light jacket.';
      case 'thunderstorm':
        return 'Thunderstorms possible. Stay indoors and avoid open areas.';
      case 'snow':
        return 'Snowfall possible. Wear warm clothes and avoid slippery roads.';
      default:
        return 'Clear and sunny. Stay hydrated and wear sunscreen.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[300]!, Colors.blue[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          getWeatherIcon(currentWeather['condition'] ?? ''),
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentWeather['condition'] ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${currentWeather['temperature'] ?? '--'}°C',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Feels like ${currentWeather['feels_like'] ?? '--'}°C',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherDetail(
                          'Humidity',
                          '${currentWeather['humidity'] ?? '--'}%',
                          Icons.water_drop,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildWeatherDetail(
                          'Wind Speed',
                          '${currentWeather['wind_speed'] ?? '--'} km/h',
                          Icons.air,
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherDetail(
                          'UV Index',
                          '${currentWeather['uv_index'] ?? '--'}',
                          Icons.sunny,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildWeatherDetail(
                          'Visibility',
                          '${currentWeather['visibility'] ?? '--'} km',
                          Icons.visibility,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '5-Day Forecast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...forecastData.map((day) {
                    final date = DateTime.parse(day['date']);
                    final formattedDate = DateFormat.EEEE().format(
                      date,
                    ); // Day of the week
                    final condition = day['condition'];
                    return _buildDayForecast(
                      formattedDate,
                      condition,
                      '${day['temp']}°',
                      '',
                      getWeatherIcon(condition),
                      getWeatherColor(condition),
                    );
                  }),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: getWeatherColor(
                            currentWeather['condition'] ?? '',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentWeather['condition'] ?? 'Advisory'} Advisory',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                getAdvisory(currentWeather['condition'] ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherDetail(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDayForecast(
    String day,
    String condition,
    String high,
    String low,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(condition, style: const TextStyle(fontSize: 16)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                high,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (low.isNotEmpty)
                Text(
                  low,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
