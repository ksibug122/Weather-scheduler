import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClothingPage extends StatefulWidget {
  const ClothingPage({super.key});

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  int currentTemp = 0;
  int currentHumidity = 0;
  String currentCondition = '';
  String selectedActivity = 'Casual';
  bool isLoading = true;

  final List<String> activities = [
    'Casual',
    'Work',
    'Exercise',
    'Outdoor',
    'Formal',
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const String apiKey = '9eae7cdd6e58123088ffaa474269ac4e';
    const double lat = 14.5995;
    const double lon = 120.9842;

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currentTemp = data['main']['temp'].round();
        currentHumidity = data['main']['humidity'];
        currentCondition = data['weather'][0]['main'];
        isLoading = false;
      });
    } else {
      setState(() {
        currentCondition = 'Error';
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon() {
    switch (currentCondition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return Icons.beach_access;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      appBar: AppBar(
        title: const Text('Clothing Recommendations'),
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
                        colors: [Colors.orange[300]!, Colors.orange[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(getWeatherIcon(), size: 50, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          '$currentTemp°C • $currentCondition',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Humidity: $currentHumidity%',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        final isSelected = selectedActivity == activity;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedActivity = activity),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue[500]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              activity,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended Clothing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...getClothingRecommendations().map(_buildClothingCategory),
                  const SizedBox(height: 24),
                  _buildComfortIndex(),
                ],
              ),
            ),
    );
  }

  List<ClothingCategory> getClothingRecommendations() {
    List<ClothingCategory> base;

    switch (selectedActivity) {
      case 'Work':
        base = [
          ClothingCategory('Tops', Icons.checkroom, Colors.blue, [
            'Light dress shirt',
            'Polo shirt',
            'Blouse',
          ]),
          ClothingCategory('Bottoms', Icons.straighten, Colors.green, [
            'Chinos',
            'Skirt',
            'Dress pants',
          ]),
          ClothingCategory('Footwear', Icons.directions_walk, Colors.brown, [
            'Loafers',
            'Flats',
            'Dress shoes',
          ]),
        ];
        break;
      case 'Exercise':
        base = [
          ClothingCategory('Tops', Icons.fitness_center, Colors.red, [
            'Workout shirt',
            'Tank top',
            'Moisture-wicking tee',
          ]),
          ClothingCategory('Bottoms', Icons.directions_run, Colors.orange, [
            'Shorts',
            'Leggings',
            'Joggers',
          ]),
          ClothingCategory('Footwear', Icons.directions_walk, Colors.purple, [
            'Running shoes',
            'Trainers',
            'Sneakers',
          ]),
        ];
        break;
      case 'Outdoor':
        base = [
          ClothingCategory('Tops', Icons.wb_sunny, Colors.orange, [
            'Light jacket',
            'Long sleeve tee',
          ]),
          ClothingCategory('Bottoms', Icons.landscape, Colors.green, [
            'Hiking pants',
            'Capris',
          ]),
          ClothingCategory('Accessories', Icons.shield, Colors.blue, [
            'Hat',
            'Water bottle',
          ]),
        ];
        break;
      case 'Formal':
        base = [
          ClothingCategory('Tops', Icons.business_center, Colors.indigo, [
            'Blazer',
            'Button-up shirt',
          ]),
          ClothingCategory('Bottoms', Icons.business, Colors.grey, [
            'Formal pants',
            'Skirt',
          ]),
          ClothingCategory('Footwear', Icons.star, Colors.black, [
            'Heels',
            'Formal shoes',
          ]),
        ];
        break;
      default:
        base = [
          ClothingCategory('Tops', Icons.checkroom, Colors.teal, [
            'T-shirt',
            'Sweater',
            'Shirt',
          ]),
          ClothingCategory('Bottoms', Icons.straighten, Colors.blue, [
            'Jeans',
            'Shorts',
          ]),
          ClothingCategory('Footwear', Icons.directions_walk, Colors.brown, [
            'Sneakers',
            'Sandals',
          ]),
        ];
    }

    // Weather-based additions
    if (currentCondition.toLowerCase().contains('rain')) {
      base.add(
        ClothingCategory('Rain Gear', Icons.umbrella, Colors.indigo, [
          'Umbrella',
          'Raincoat',
        ]),
      );
    } else if (currentCondition.toLowerCase().contains('cloud')) {
      base.add(
        ClothingCategory('Accessories', Icons.cloud, Colors.grey, [
          'Cap',
          'Light jacket',
        ]),
      );
    } else if (currentCondition.toLowerCase().contains('clear') &&
        currentTemp > 30) {
      base.add(
        ClothingCategory('Sun Protection', Icons.wb_sunny, Colors.orange, [
          'Hat',
          'Sunglasses',
        ]),
      );
    }

    return base;
  }

  Widget _buildClothingCategory(ClothingCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: category.color.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: category.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildComfortIndex() {
    int heat = currentTemp > 35
        ? 9
        : currentTemp > 30
        ? 7
        : currentTemp > 25
        ? 5
        : 3;
    int uv = currentCondition.toLowerCase() == 'clear' ? 8 : 4;
    int humidity = currentHumidity > 70
        ? 8
        : currentHumidity > 50
        ? 6
        : 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Comfort Index',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildComfortIndicator('Heat', heat, Colors.red),
              _buildComfortIndicator('Humidity', humidity, Colors.blue),
              _buildComfortIndicator('UV', uv, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComfortIndicator(String label, int value, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / 10,
                strokeWidth: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '$value/10',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class ClothingCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> items;

  ClothingCategory(this.name, this.icon, this.color, this.items);
}
