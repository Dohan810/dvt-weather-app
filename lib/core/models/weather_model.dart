import 'dart:convert';

class WeatherModel {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final String main;
  final String description;
  final String icon;
  final double windSpeed;
  final int windDeg;
  final double? windGust;
  final int clouds;
  final int visibility;
  final int dt;
  final String country;
  final int sunrise;
  final int sunset;
  final String name;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    this.pressure = 0,
    this.humidity = 0,
    required this.main,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.windDeg,
    this.windGust = 0,
    required this.clouds,
    required this.visibility,
    this.dt = 0,
    this.country = "",
    required this.sunrise,
    required this.sunset,
    required this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      humidity: json['main']['humidity'] ?? 0,
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'],
      windGust: json['wind']['gust']?.toDouble() ?? null,
      clouds: json['clouds']['all'],
      visibility: json['visibility'],
      dt: json['dt'] ?? 0,
      country: json['sys']['country'] ?? "Unknown",
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      name: json['name'],
    );
  }

  static WeatherModel fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return WeatherModel.fromJson(json);
  }
}
