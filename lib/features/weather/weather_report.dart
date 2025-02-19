// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_wise/shared/widgets/k_add_space.dart';
import '../../loading_screen.dart';
import '../../shared/widgets/k_header.dart';
import '../../shared/widgets/k_drawer.dart';
import '../../shared/widgets/sun_path_widget.dart';
import '../../shared/widgets/additional_details_widget.dart';
import '../../shared/utils/permissions_utils.dart';
import '../../core/cubit/weather_cubit.dart';
import '../../core/base/service_locator.dart';
import 'weather_report.func.dart';

class WeatherReportScreen extends StatefulWidget {
  const WeatherReportScreen({super.key});

  @override
  State<WeatherReportScreen> createState() => _WeatherReportScreenState();
}

class _WeatherReportScreenState extends State<WeatherReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WeatherCubit _weatherCubit;

  @override
  void initState() {
    super.initState();
    _weatherCubit = getIt<WeatherCubit>();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await PermissionsUtils.getCurrentLocation();
      if (position != null) {
        _weatherCubit.fetchWeather(position.latitude, position.longitude);
      } else {
        _weatherCubit.fetchWeather(-26.086244, 27.960827);
      }
    } catch (e) {
      _weatherCubit.fetchWeather(-26.086244, 27.960827);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Using default location: $e')),
      );
    }
  }

  Widget _buildTemperatureDisplay(WeatherState state) {
    if (state is! WeatherLoaded) return const SizedBox.shrink();

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        image: DecorationImage(
          image: AssetImage('assets/images/weather/${getBackgroundAsset()}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTemperatureString(
                state.weatherData.temperature, _weatherCubit.unit),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            state.weatherData.main,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherState state) {
    if (state is! WeatherLoaded) return const SizedBox.shrink();

    return Container(
      color: getBackgroundColor(),
      child: Column(
        children: [
          _buildTemperatureRow(state),
          const Divider(color: Colors.white),
          ...groupForecastByDay(state.forecastData).map(
            (e) => WeatherForecastTile(
              day: DateFormat('EEEE').format(e.dateTime),
              temperature:
                  getTemperatureString(e.temperature, _weatherCubit.unit),
            ),
          ),
          const KAddSpace(multiplier: 4),
          const Divider(color: Colors.white),
          SunPathWidget(weatherData: state.weatherData),
          const KAddSpace(multiplier: 4),
          AdditionalDetailsWidget(weatherData: state.weatherData),
        ],
      ),
    );
  }

  Widget _buildTemperatureRow(WeatherLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            getTemperatureString(
                state.weatherData.tempMin, _weatherCubit.unit, 'min'),
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            getTemperatureString(
                state.weatherData.temperature, _weatherCubit.unit, 'Current'),
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            getTemperatureString(
                state.weatherData.tempMax, _weatherCubit.unit, 'max'),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _weatherCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const KDrawer(),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        bloc: _weatherCubit,
        builder: (context, state) {
          return Stack(
            children: [
              if (state is WeatherLoading || state is WeatherInitial)
                const LoadingScreen()
              else
                ListView(
                  children: [
                    _buildTemperatureDisplay(state),
                    _buildWeatherDetails(state),
                  ],
                ),
              if (PermissionsUtils.isLocationEnabled)
                KHeader(scaffoldKey: _scaffoldKey),
            ],
          );
        },
      ),
    );
  }
}
