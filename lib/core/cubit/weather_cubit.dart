import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/weather_api.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApi weatherApi;
  String unit = 'metric';
  String selectedLocation = 'Current Location';

  WeatherCubit(this.weatherApi) : super(WeatherInitial());

  Future<void> fetchWeather(double lat, double lon) async {
    try {
      emit(WeatherLoading());
      final weatherData = await weatherApi.getWeather(lat, lon, unit);
      final forecastData = await weatherApi.getForecast(lat, lon, unit);
      emit(WeatherLoaded(weatherData, forecastData));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  void changeUnit(String newUnit) {
    unit = newUnit;
    emit(WeatherInitial()); // Reset state to trigger UI update
    fetchWeather(-26.086244, 27.960827); // Fetch weather with new unit
  }

  void setSelectedLocation(String location) {
    selectedLocation = location;
    emit(WeatherInitial()); // Reset state to trigger UI update
  }
}
