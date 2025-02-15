import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/models/weather_model.dart';

class SunPathWidget extends StatelessWidget {
  final WeatherModel weatherData;

  const SunPathWidget({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sunriseTime =
        DateTime.fromMillisecondsSinceEpoch(weatherData.sunrise * 1000);
    final sunsetTime =
        DateTime.fromMillisecondsSinceEpoch(weatherData.sunset * 1000);
    final currentTime = DateTime.now();

    final totalDaylight = sunsetTime.difference(sunriseTime).inMinutes;
    final elapsedDaylight = currentTime.difference(sunriseTime).inMinutes;
    final sunPosition = (elapsedDaylight / totalDaylight).clamp(0.0, 1.0);

    return Container(
      color: Colors.blueGrey,
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 64),
              child: Image.asset(
                'assets/images/parabole_line.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              children: [
                Text('Sun Rise', style: TextStyle(color: Colors.white)),
                Text(DateFormat('hh:mm a').format(sunriseTime),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                Text('Sun Set', style: TextStyle(color: Colors.white)),
                Text(DateFormat('hh:mm a').format(sunsetTime),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * sunPosition - 24,
            top: 80 - (100 * sunPosition),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/sun.png',
                  fit: BoxFit.fill,
                  height: 80,
                  width: 80,
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * sunPosition - 24,
            top: 110 - (100 * sunPosition),
            child: Container(
              padding: EdgeInsets.only(top: 50, left: 8, right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                DateFormat('hh:mm a').format(currentTime),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
