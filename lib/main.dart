import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_wise/coin_screen.dart';
import 'package:weather_wise/features/weather_detective.dart';
import 'package:weather_wise/shared/weather_report_card.dart';
import 'package:weather_wise/splash_screen.dart';
import 'package:weather_wise/weather_report.dart';
import 'core/service_locator.dart';
import 'theme.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Weather Wise',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SafeArea(child: const WeatherReportScreen()),
      routes: {
        '/detective': (context) => WeatherDetectiveScreen(),
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

