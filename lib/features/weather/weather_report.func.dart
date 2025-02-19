import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_wise/shared/widgets/k_add_space.dart';
import '../../core/models/forecast_model.dart';
import '../../core/cubit/weather_cubit.dart';
import '../../core/base/service_locator.dart';

class WeatherForecastTile extends StatelessWidget {
  final String day;
  final String temperature;

  const WeatherForecastTile({
    super.key,
    required this.day,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const Icon(
            Icons.wb_sunny,
            color: Colors.white,
          ),
          const KAddSpace(multiplier: 2),
          Expanded(
            child: Text(
              temperature,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

double convertTemperature(double kelvin) => kelvin;

String getTemperatureString(double temperature, String unit, [String? label]) {
  final formattedTemp = convertTemperature(temperature).toStringAsFixed(1);
  final unitSymbol = unit == 'metric' ? 'C' : 'F';
  final labelText = label != null ? ' $label' : '';
  return '$formattedTemp°$unitSymbol$labelText';
}

Color getBackgroundColor() {
  final weatherCondition = getIt<WeatherCubit>().state is WeatherLoaded
      ? (getIt<WeatherCubit>().state as WeatherLoaded).weatherData.main
      : '';
  switch (weatherCondition.toLowerCase()) {
    case 'rain':
      return const Color(0xFF57575D);
    case 'clouds':
      return const Color(0xFF54717A);
    case 'clear':
      return const Color(0xFF47AB2F);
    default:
      return Colors.blue;
  }
}

String getBackgroundAsset() {
  final weatherCondition = getIt<WeatherCubit>().state is WeatherLoaded
      ? (getIt<WeatherCubit>().state as WeatherLoaded).weatherData.main
      : '';
  String prefix = getIt<WeatherCubit>().selectedScene == 'Forest Scene'
      ? 'forest_'
      : 'sea_';
  switch (weatherCondition.toLowerCase()) {
    case 'rain':
      return "${prefix}rainy.png";
    case 'clouds':
      return "${prefix}cloudy.png";
    case 'clear':
      return "${prefix}sunny.png";
    default:
      return "${prefix}sunny.png";
  }
}

String getWeatherState() {
  final weatherCondition = getIt<WeatherCubit>().state is WeatherLoaded
      ? (getIt<WeatherCubit>().state as WeatherLoaded).weatherData.main
      : '';
  return weatherCondition;
}

List<ForecastModel> groupForecastByDay(List<ForecastModel> forecastData) {
  final Map<String, List<ForecastModel>> groupedData = {};
  for (var forecast in forecastData) {
    final day = DateFormat('yyyy-MM-dd').format(forecast.dateTime);
    if (!groupedData.containsKey(day)) {
      groupedData[day] = [];
    }
    groupedData[day]!.add(forecast);
  }

  final List<ForecastModel> groupedForecast = [];
  groupedData.forEach((day, forecasts) {
    final avgTemp =
        forecasts.map((f) => f.temperature).reduce((a, b) => a + b) /
            forecasts.length;
    groupedForecast.add(ForecastModel(
      dateTime: DateTime.parse(day),
      temperature: avgTemp,
      main: forecasts.first.main,
    ));
  });

  return groupedForecast;
}
