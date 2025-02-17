import 'dart:convert';
import 'dart:io';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../database/database_helper.dart';

class WeatherApi {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'c8c70dc3c906d40947ccc93b0c4d5b97';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<WeatherModel> getWeather(double lat, double lon, String unit) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&units=$unit&appid=$_apiKey'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return WeatherModel.fromJsonString(responseBody);
      } else {
        throw Exception('Failed to load weather data');
      }
    } finally {
      client.close();
    }
  }

  Future<List<ForecastModel>> getForecast(double lat, double lon, String unit) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&units=$unit&appid=$_apiKey'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return ForecastModel.fromJsonString(responseBody);
      } else {
        throw Exception('Failed to load forecast data');
      }
    } finally {
      client.close();
    }
  }
}
