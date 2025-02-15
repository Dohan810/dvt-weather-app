import 'package:flutter/material.dart';
import 'shared/k_header.dart';
import 'shared/k_drawer.dart';

class WeatherReportScreen extends StatefulWidget {
  const WeatherReportScreen({super.key});

  @override
  State<WeatherReportScreen> createState() => _WeatherReportScreenState();
}

class _WeatherReportScreenState extends State<WeatherReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: KDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/weather/forest_cloudy.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '25°',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'SUNNY',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              '19° min',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '25° Current',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '27° max',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.white),
                      Expanded(
                        child: ListView(
                          children: const [
                            WeatherForecastTile(day: 'Today', temperature: '21°'),
                            WeatherForecastTile(day: 'Tuesday', temperature: '20°'),
                            WeatherForecastTile(day: 'Wednesday', temperature: '23°'),
                            WeatherForecastTile(day: 'Thursday', temperature: '27°'),
                            WeatherForecastTile(day: 'Friday', temperature: '28°'),
                            WeatherForecastTile(day: 'Saturday', temperature: '30°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          KHeader(scaffoldKey: _scaffoldKey),
        ],
      ),
    );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.wb_sunny,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                temperature,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}