import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/k_header.dart';
import 'shared/k_drawer.dart';
import 'shared/sun_path_widget.dart';
import 'shared/additional_details_widget.dart';
import 'core/api/weather_api.dart';
import 'core/cubit/weather_cubit.dart';
import 'core/models/weather_model.dart';
import 'core/models/forecast_model.dart';
import 'package:intl/intl.dart';

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
    _weatherCubit = WeatherCubit(WeatherApi());
    _weatherCubit.fetchWeather(-26.086244, 27.960827);
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
      drawer: KDrawer(),
      body: BlocProvider(
        create: (_) => _weatherCubit,
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/weather/forest_cloudy.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is WeatherLoaded)
                            Text(
                              '${(state.weatherData.temperature - 273.15).toStringAsFixed(1)}°',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (state is WeatherLoaded)
                            Text(
                              state.weatherData.main,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          if (state is WeatherLoading)
                            CircularProgressIndicator(),
                          if (state is WeatherError)
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      child: Column(
                        children: [
                          if (state is WeatherLoaded)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${(state.weatherData.tempMin - 273.15).toStringAsFixed(1)}° min',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${(state.weatherData.temperature - 273.15).toStringAsFixed(1)}° Current',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${(state.weatherData.tempMax - 273.15).toStringAsFixed(1)}° max',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Divider(color: Colors.white),
                          if (state is WeatherLoaded)
                            Column(
                              children: [
                                ..._groupForecastByDay(state.forecastData).map(
                                  (e) {
                                    return WeatherForecastTile(
                                      day:
                                          DateFormat('EEEE').format(e.dateTime),
                                      temperature:
                                          '${(e.temperature - 273.15).toStringAsFixed(1)}°',
                                    );
                                  },
                                ).toList()
                              ],
                            ),
                          if (state is WeatherLoaded)
                            SunPathWidget(weatherData: state.weatherData),
                          if (state is WeatherLoaded)
                            AdditionalDetailsWidget(weatherData: state.weatherData),
                        ],
                      ),
                    ),
                  ],
                ),
                KHeader(scaffoldKey: _scaffoldKey),
              ],
            );
          },
        ),
      ),
    );
  }

  List<ForecastModel> _groupForecastByDay(List<ForecastModel> forecastData) {
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
}

class WeatherForecastTile extends StatelessWidget {
  final String day;
  final String temperature;

  const WeatherForecastTile({
    Key? key,
    required this.day,
    required this.temperature,
  }) : super(key: key);

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
          const SizedBox(width: 8),
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
