import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wise/core/service_locator.dart';
import '../core/cubit/weather_cubit.dart';

class WeatherReportCard extends StatelessWidget {
  final GlobalKey cardKey;

  const WeatherReportCard({Key? key, required this.cardKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WeatherCubit weatherCubit = getIt<WeatherCubit>();

    return RepaintBoundary(
      key: cardKey,
      child: Card(
        child: Container(
          height: 350,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/weather/${weatherCubit.selectedScene == 'Forest Scene' ? 'forest_' : 'sea_'}cloudy.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Card(
            margin: const EdgeInsets.all(32.0),
            child: Container(
              height: 350,
              width: MediaQuery.sizeOf(context).width,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    left: -20,
                    child: Text(
                      'Weather ',
                      style: TextStyle(
                        fontSize: 86,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 10,
                    child: Text(
                      '12:43 PM',
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
                            ' 25°',
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Shinny',
                          style: TextStyle(
                            fontSize: 36,
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
                      '06 March 2024',
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
      ),
    );
  }
}
