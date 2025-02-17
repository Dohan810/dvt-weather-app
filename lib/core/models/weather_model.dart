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
    required this.pressure,
    required this.humidity,
    required this.main,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.windDeg,
     this.windGust,
    required this.clouds,
    required this.visibility,
    required this.dt,
    required this.country,
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
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'],
      windGust: json['wind']['gust']?.toDouble() ?? null,
      clouds: json['clouds']['all'],
      visibility: json['visibility'],
      dt: json['dt'],
      country: json['sys']['country'],
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
