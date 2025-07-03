import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'dart:async';

class MoodcastPage extends StatefulWidget {
  const MoodcastPage({super.key});

  @override
  State<MoodcastPage> createState() => _MoodcastPageState();
}

class _MoodcastPageState extends State<MoodcastPage> {
  String selectedMood = 'Happy';
  final List<String> moods = [
    'Happy',
    'Calm',
    'Energetic',
    'Relaxed',
    'Focused',
  ];
  final List<String> moodEmojis = ['😊', '😌', '⚡', '🧘', '🎯'];

  Map<String, dynamic>? weatherData;
  List<Map<String, dynamic>> weeklyForecast = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherInfo();
  }

  Future<void> fetchWeatherInfo() async {
    const double lat = 14.5995;
    const double lon = 120.9842;

    final service = WeatherService();
    final current = await service.getCurrentWeather(lat, lon);
    final forecast = await service.get5DayForecast(lat, lon);

    setState(() {
      weatherData = current;
      weeklyForecast = forecast;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Moodcast',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[200]!, Colors.yellow[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            getWeatherIcon(weatherData!['condition']),
                            size: 60,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Perfect Weather for Good Vibes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weatherData!['temperature']}°C ${weatherData!['condition']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Mood Boost: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '+${(100 - weatherData!['humidity']).clamp(0, 100)}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: moods.length,
                        itemBuilder: (context, index) {
                          final mood = moods[index];
                          final emoji = moodEmojis[index];
                          final isSelected = selectedMood == mood;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMood = mood;
                              });
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue[200]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mood,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Weather & Mood Insights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.psychology, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Today\'s Insight',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            getMoodInsight(selectedMood),
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Weekly Mood Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...weeklyForecast.map(
                      (day) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getWeatherIcon(day['condition']),
                              size: 32,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day['date'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${day['condition']} • ${day['temp']}°C',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                getMoodFromWeather(day['condition']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.lightbulb, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Perfect Activities for Today',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...getActivitiesForMood(
                            selectedMood,
                            weatherData!['condition'],
                          ).map(
                            (activity) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      activity,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Icons.umbrella;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.wb_sunny;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  String getMoodInsight(String mood) {
    final now = DateTime.now();
    final isNight = now.hour < 6 || now.hour >= 18;

    if (isNight) {
      switch (mood) {
        case 'Happy':
          return 'Evenings are perfect for winding down while keeping a smile. Reflect on good moments today.';
        case 'Calm':
          return 'The quiet night supports deep calmness. Great time for reflection or meditation.';
        case 'Energetic':
          return 'Use that leftover energy to dance around or prep for tomorrow!';
        case 'Relaxed':
          return 'Nighttime is ideal for slow music, tea, and cozy moments.';
        case 'Focused':
          return 'If you still feel focused, try organizing or journaling your thoughts before bed.';
        default:
          return 'Evenings are great for self-care and recharging.';
      }
    } else {
      switch (mood) {
        case 'Happy':
          return 'Sunny weather like today naturally boosts serotonin levels! Bright daylight enhances your cheerful mood.';
        case 'Calm':
          return 'The gentle warmth and clear skies provide a peaceful atmosphere for mindfulness.';
        case 'Energetic':
          return 'Perfect weather to channel your energy into productive or fun outdoor activities.';
        case 'Relaxed':
          return 'Comfortable conditions make it ideal for stress relief and leisure.';
        case 'Focused':
          return 'Clear weather helps improve concentration. Make the most of it!';
        default:
          return 'The day supports a positive mental outlook—embrace it fully.';
      }
    }
  }

  List<String> getActivitiesForMood(String mood, String condition) {
    final isRainy = condition.toLowerCase().contains('rain');
    switch (mood) {
      case 'Happy':
        return isRainy
            ? [
                'Watch a funny movie',
                'Do indoor karaoke',
                'Call a friend',
                'Cook your favorite meal',
              ]
            : [
                'Take a walk in the park',
                'Picnic with friends',
                'Play outdoor games',
                'Visit a market',
              ];
      case 'Calm':
        return [
          'Practice yoga',
          'Read a book',
          'Meditate',
          'Listen to relaxing music',
        ];
      case 'Energetic':
        return isRainy
            ? [
                'Home workout',
                'Dance party',
                'Jump rope indoors',
                'Indoor sports',
              ]
            : ['Go for a run', 'Bike ride', 'Swimming', 'Hiking'];
      case 'Relaxed':
        return [
          'Lay on the couch',
          'Watch clouds/rain',
          'Listen to lo-fi',
          'Sketch or doodle',
        ];
      case 'Focused':
        return [
          'Organize your workspace',
          'Journal your goals',
          'Learn something new',
          'Do a focused task',
        ];
      default:
        return ['Enjoy the weather!'];
    }
  }

  String getMoodFromWeather(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return 'Cozy';
      case 'clouds':
        return 'Peaceful';
      case 'clear':
        return 'Optimistic';
      case 'thunderstorm':
        return 'Introspective';
      default:
        return 'Reflective';
    }
  }
}
