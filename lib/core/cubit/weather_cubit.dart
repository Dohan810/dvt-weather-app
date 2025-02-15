import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/weather_api.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApi weatherApi;

  WeatherCubit(this.weatherApi) : super(WeatherInitial());

  Future<void> fetchWeather(double lat, double lon) async {
    try {
      emit(WeatherLoading());
      final weatherData = await weatherApi.getWeather(lat, lon);
      final forecastData = await weatherApi.getForecast(lat, lon);
      emit(WeatherLoaded(weatherData, forecastData));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
