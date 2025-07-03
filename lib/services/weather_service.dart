import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final apiKey = '9eae7cdd6e58123088ffaa474269ac4e';
  final baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';
    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);
    final w = data['weather'][0];
    final m = data['main'];
    final wind = data['wind'];

    return {
      'condition': w['main'],
      'temperature': m['temp'].round(),
      'feels_like': m['feels_like'].round(),
      'humidity': m['humidity'],
      'wind_speed': wind['speed'],
      'visibility': (data['visibility'] / 1000).toString(), // in km
    };
  }

  Future<List<Map<String, dynamic>>> get5DayForecast(
    double lat,
    double lon,
  ) async {
    final url =
        '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&cnt=40&appid=$apiKey';
    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final Map<String, Map<String, dynamic>> daily = {};
    for (var item in data['list']) {
      final date = DateTime.parse(item['dt_txt']).toLocal();
      final key = date.toIso8601String().split('T').first;
      final w = item['weather'][0];
      if (date.hour == 12 && !daily.containsKey(key)) {
        daily[key] = {
          'date': key,
          'condition': w['main'],
          'temp': item['main']['temp'].round(),
        };
      }
    }
    return daily.values.take(5).toList();
  }

  // ✅ NEW method: Next 24 hours forecast in 3-hour steps
  Future<List<Map<String, dynamic>>> getNext24HourForecast(
    double lat,
    double lon,
  ) async {
    final url =
        '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&cnt=40&appid=$apiKey';
    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final now = DateTime.now();
    final List<Map<String, dynamic>> next24Hours = [];

    for (var item in data['list']) {
      final dt = DateTime.parse(item['dt_txt']).toLocal();
      if (dt.isAfter(now) && dt.isBefore(now.add(const Duration(hours: 25)))) {
        next24Hours.add({
          'time': dt,
          'temp': item['main']['temp'].round(),
          'condition': item['weather'][0]['main'],
        });
      }
    }

    return next24Hours;
  }
}
