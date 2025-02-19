// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_wise/features/onboarding/coin_screen.dart';
import 'package:weather_wise/features/weather/weather_detective.dart';
import 'package:weather_wise/splash_screen.dart';
import 'package:weather_wise/features/weather/weather_report.dart';
import 'core/base/service_locator.dart';
import 'core/base/theme.dart';

void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Weather Wise',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SafeArea(child: SplashScreen()),
      routes: {
        '/detective': (context) => const SafeArea(child: WeatherDetectiveScreen()),
        '/report': (context) => const SafeArea(child: WeatherReportScreen()),
        '/coin': (context) => const SafeArea(child: CoinScreen()),
      },
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme(String label) {
    isDarkMode = label != "Light";
    notifyListeners();
  }
}

