import 'package:get_it/get_it.dart';
import 'package:weather_wise/core/api/weather_api.dart';
import 'package:weather_wise/core/cubit/weather_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<WeatherCubit>(WeatherCubit(WeatherApi()));
}
