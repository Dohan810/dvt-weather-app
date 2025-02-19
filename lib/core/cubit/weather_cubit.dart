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
  String selectedScene = 'Forest Scene';
  String selectedTheme = 'Light';

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
  }

  void setSelectedLocation(String location) {
    selectedLocation = location;
    emit(WeatherInitial()); // Reset state to trigger UI update
  }

  void changeScene(String scene) {
    selectedScene = scene;
    if (state is WeatherLoaded) {
      final loadedState = state as WeatherLoaded;
      emit(loadedState.copyWith(scene: scene));
    } else {
      emit(WeatherSceneChanged(scene));
    }
  }

  void changeTheme(String theme) {
    selectedTheme = theme;
    // emit(WeatherThemeChanged(theme));
  }
}
