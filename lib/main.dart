import 'package:flutter/material.dart';
import 'package:weather_wise/coin_screen.dart';
import 'package:weather_wise/features/weather_detective.dart';
import 'package:weather_wise/shared/weather_report_card.dart';
import 'package:weather_wise/splash_screen.dart';
import 'package:weather_wise/weather_report.dart';
import 'core/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Wise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(child: const WeatherReportScreen()),
      routes: {
        '/detective': (context) => WeatherDetectiveScreen(),
      },
    );
  }
}

