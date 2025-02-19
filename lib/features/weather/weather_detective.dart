// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:weather_wise/shared/widgets/k_add_space.dart';

class WeatherDetectiveScreen extends StatefulWidget {
  const WeatherDetectiveScreen({super.key});

  @override
  State<WeatherDetectiveScreen> createState() => _WeatherDetectiveScreenState();
}

class _WeatherDetectiveScreenState extends State<WeatherDetectiveScreen> {
  int _score = 0;
  int _totalAttempts = 0;
  final List<Map<String, dynamic>> _weatherOptions = [
    {'icon': Icons.wb_sunny, 'label': 'Sunny'},
    {'icon': Icons.beach_access, 'label': 'Raining'},
    {'icon': Icons.cloud, 'label': 'Cloudy'},
    {'icon': Icons.ac_unit, 'label': 'Snowing'},
  ];
  late Map<String, dynamic> _correctOption;
  late List<Map<String, dynamic>> _displayOptions;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final random = Random();
    _correctOption = _weatherOptions[random.nextInt(_weatherOptions.length)];
    _displayOptions = List.from(_weatherOptions)..shuffle();
  }

  void _handleOptionTap(Map<String, dynamic> option) {
    setState(() {
      _totalAttempts++;
      if (option == _correctOption) {
        _score++;
      }
      _generateNewQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    int percentage = (_score > 0 ? (_score / _totalAttempts) * 100 : 0).toInt();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: MediaQuery.sizeOf(context).width / 1.5,
              top: -0,
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  percentage > 0 ? "$percentage%" : "Weather",
                  style: TextStyle(
                      fontSize: 68,
                      fontWeight: FontWeight.bold,
                      color: percentage == 0
                          ? Theme.of(context).canvasColor
                          : percentage > 50
                              ? Colors.green
                              : Colors.red),
                ),
              ),
            ),
            Positioned(
              left: -100,
              top: (MediaQuery.sizeOf(context).height / 6),
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  _correctOption['icon'],
                  size: 300,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                    ),
                  ),
                  const KAddSpace(multiplier: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: const Text(
                          "Weather\nDetective",
                          style: TextStyle(fontSize: 40, height: 1.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            '$_score / $_totalAttempts',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "What's the weather?",
                            style: TextStyle(fontSize: 24),
                          ),
                          const KAddSpace(multiplier: 4),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(500)),
                              color: Theme.of(context).canvasColor,
                            ),
                            child: Icon(
                              _correctOption['icon'],
                              size: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const KAddSpace(multiplier: 4),
                  Row(
                    children: [
                      _buildWeatherOption(_displayOptions[0]),
                      const SizedBox(
                        height: 16,
                        width: 16,
                      ),
                      _buildWeatherOption(_displayOptions[1]),
                    ],
                  ),
                  const KAddSpace(multiplier: 4),
                  Row(
                    children: [
                      _buildWeatherOption(_displayOptions[2]),
                      const SizedBox(
                        height: 16,
                        width: 16,
                      ),
                      _buildWeatherOption(_displayOptions[3]),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherOption(Map<String, dynamic> option) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleOptionTap(option),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(option['icon'], size: 40),
              const KAddSpace(multiplier: 2),
              Text(option['label'], style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
