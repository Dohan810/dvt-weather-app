import 'dart:convert';

class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String main;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.main,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp']?.toDouble(),
      main: json['weather'][0]['main'],
    );
  }

  static List<ForecastModel> fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> list = json['list'];
    return list.map((item) => ForecastModel.fromJson(item)).toList();
  }
}
