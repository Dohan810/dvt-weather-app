part of 'weather_cubit.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weatherData;
  final List<ForecastModel> forecastData;

  const WeatherLoaded(this.weatherData, this.forecastData);

  @override
  List<Object> get props => [weatherData, forecastData];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
