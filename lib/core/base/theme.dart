import 'package:flutter/material.dart';

// Light theme colors
const Color lightPrimaryColor = Color(0xFF2B3151);
const Color lightSecondaryColor = Color(0xFF4A90E2);
const Color lightBackgroundColor = Color(0xFFF3F6F9);
const Color lightScaffoldBackgroundColor = Color(0xFFFDFEFB);
const Color lightCardColor = Color(0xFFFFFFFF);
const Color lightBackgroundCardColor = Color(0xFFF0F0F0);
const Color lightButtonColor = Color(0xFF4A90E2);

// Dark theme colors
const Color darkPrimaryColor = Color.fromARGB(255, 228, 228, 228);
const Color darkSecondaryColor = Color.fromARGB(255, 255, 255, 255);
const Color darkBackgroundColor = Color(0xFF292F33);
const Color darkScaffoldBackgroundColor = Color(0xFF2B3151);
const Color darkCardColor = Color(0xFF3A3A3A);
const Color darkBackgroundCardColor = Color(0xFF1F1F1F);
const Color darkButtonColor = Color(0xFF4A90E2);

const Color darkCanvasColor = Color.fromARGB(255, 122, 122, 122);
const Color lightCanvasColor = Color(0xFFF3F6F9);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: lightPrimaryColor,
    secondary: lightSecondaryColor,
  ),
  scaffoldBackgroundColor: lightScaffoldBackgroundColor,
  cardColor: lightCardColor,
  canvasColor: lightCanvasColor ,
  buttonTheme: const ButtonThemeData(buttonColor: lightButtonColor),
  textTheme: const TextTheme(
    // Display
    displayLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 34),
    displayMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
    displaySmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 26),

    // Headline
    headlineLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),
    headlineMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),

    // Title
    titleLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
    titleMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14),
    titleSmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold, fontSize: 12),

    // Body
    bodyLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 16),
    bodyMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 14),
    bodySmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 12),

    // Label
    labelLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 16),
    labelMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 14),
    labelSmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.normal, fontSize: 12),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: darkPrimaryColor,
    secondary: darkSecondaryColor,
  ),
  scaffoldBackgroundColor: darkScaffoldBackgroundColor,
  cardColor: darkCardColor,
  canvasColor: darkCanvasColor,
  buttonTheme: const ButtonThemeData(buttonColor: darkButtonColor),
  textTheme: const TextTheme(
    // Display
    displayLarge: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 34),
    displayMedium: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 30),
    displaySmall: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 26),

    // Headline
    headlineLarge: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 22),
    headlineMedium: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 18),

    // Title
    titleLarge: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
    titleMedium: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
    titleSmall: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 12),

    // Body
    bodyLarge: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 16),
    bodyMedium: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 14),
    bodySmall: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 12),

    // Label
    labelLarge: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 16),
    labelMedium: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 14),
    labelSmall: TextStyle(color: darkSecondaryColor, fontWeight: FontWeight.normal, fontSize: 12),
    
  ),
);
