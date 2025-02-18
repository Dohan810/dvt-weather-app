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
  final String scene;

  const WeatherLoaded(this.weatherData, this.forecastData, {this.scene = 'Forest Scene'});

  @override
  List<Object> get props => [weatherData, forecastData, scene];

  WeatherLoaded copyWith({String? scene}) {
    return WeatherLoaded(
      weatherData,
      forecastData,
      scene: scene ?? this.scene,
    );
  }
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

class WeatherSceneChanged extends WeatherState {
  final String scene;

  const WeatherSceneChanged(this.scene);

  @override
  List<Object> get props => [scene];
}

class WeatherSceneUpdated extends WeatherState {
  final String scene;

  const WeatherSceneUpdated(this.scene);

  @override
  List<Object> get props => [scene];
}
