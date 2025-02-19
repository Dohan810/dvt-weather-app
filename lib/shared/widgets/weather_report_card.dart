import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wise/core/base/service_locator.dart';
import 'package:weather_wise/features/weather/weather_report.dart';
import 'package:intl/intl.dart';
import '../../../core/cubit/weather_cubit.dart';

class WeatherReportCard extends StatelessWidget {
  final GlobalKey cardKey;

  const WeatherReportCard({Key? key, required this.cardKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WeatherCubit weatherCubit = getIt<WeatherCubit>();

    return RepaintBoundary(
      key: cardKey,
      child: BlocBuilder<WeatherCubit, WeatherState>(
        bloc: weatherCubit,
        builder: (context, state) {
          if (state is WeatherLoaded) {
            return Card(
              child: Container(
                height: 350,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/weather/${getBackgroundAsset()}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(32.0),
                  child: Container(
                    height: 350,
                    width: MediaQuery.sizeOf(context).width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: -20,
                          left: -20,
                          child: Text(
                            'Weather ',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 35,
                          right: 10,
                          child: Text(
                            DateFormat('hh:mm a').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                child: Text(
                                  '${_convertTemperature(state.weatherData.temperature).toStringAsFixed(1)}°${weatherCubit.unit == 'metric' ? 'C' : 'F'}',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                state.weatherData.main,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 10,
                          left: 10,
                          child: Text(
                            DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  double _convertTemperature(double kelvin) {
    return kelvin;
  }
}
