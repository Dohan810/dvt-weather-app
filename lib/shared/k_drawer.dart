import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:weather_wise/core/api/weather_api.dart';
import 'package:weather_wise/shared/utils/permissions_utils.dart';
import 'k_option.dart';
import 'k_row_options.dart';
import 'k_button.dart';
import '../core/database/database_helper.dart';
import '../core/cubit/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wise/core/service_locator.dart';

class KDrawer extends StatefulWidget {
  const KDrawer({Key? key}) : super(key: key);

  @override
  _KDrawerState createState() => _KDrawerState();
}

class _KDrawerState extends State<KDrawer> {
  late VideoPlayerController _controller;
  String _selectedLocation = 'St Peterson, St Lucia, 2001';
  String _selectedUnit = '°C';
  String _selectedTimeInterval = '24 Hour';
  String _selectedScene = 'Forest Scene';
  String _selectedTheme = 'Light';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/severe_weather.mp4')
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
            _controller.setLooping(true);
          });
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final unit = await _databaseHelper.getUnit();
    if (unit != null) {
      setState(() {
        _selectedUnit = unit;
      });
      final weatherCubit = getIt<WeatherCubit>();
      weatherCubit.unit = unit == '°C' ? 'metric' : 'imperial';
    }
  }

  Future<void> _saveUnit(String unit) async {
    await _databaseHelper.saveUnit(unit);
    final weatherCubit = getIt<WeatherCubit>();
    weatherCubit.changeUnit(unit == '°C' ? 'metric' : 'imperial');
    weatherCubit.fetchWeather(-26.086244, 27.960827);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Cloudy morning will give way to afternoon sun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                KRowOptions(
                  title: 'Themes',
                  layoutType: LayoutType.row,
                  children: [
                    Expanded(
                      child: KOption(
                        text: 'Light',
                        isSelected: _selectedTheme == 'Light',
                        onTap: () {
                          setState(() {
                            _selectedTheme = 'Light';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KOption(
                        text: 'Dark',
                        isSelected: _selectedTheme == 'Dark',
                        onTap: () {
                          setState(() {
                            _selectedTheme = 'Dark';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                KRowOptions(
                  title: 'Saved Locations',
                  layoutType: LayoutType.column,
                  children: [
                    KOption(
                      text: 'Current Location',
                      isSelected: _selectedLocation == 'Current Location',
                      onTap: () {
                        setState(() {
                          _selectedLocation = 'Current Location';
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    KOption(
                      text: 'St Peterson, St Lucia, 2001',
                      isSelected:
                          _selectedLocation == 'St Peterson, St Lucia, 2001',
                      onTap: () {
                        setState(() {
                          _selectedLocation = 'St Peterson, St Lucia, 2001';
                        });
                      },
                      rightIcon: Icons.close,
                      onRightIconPress: () {
                        setState(() {
                          _selectedLocation = '';
                        });
                      },
                    ),
                  ],
                ),
                KRowOptions(
                  title: 'Units',
                  layoutType: LayoutType.row,
                  children: [
                    Expanded(
                      child: KOption(
                        text: '°C',
                        isSelected: _selectedUnit == '°C',
                        onTap: () {
                          setState(() {
                            _selectedUnit = '°C';
                          });
                          _saveUnit('°C');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KOption(
                        text: '°F',
                        isSelected: _selectedUnit == '°F',
                        onTap: () {
                          setState(() {
                            _selectedUnit = '°F';
                          });
                          _saveUnit('°F');
                        },
                      ),
                    ),
                  ],
                ),
                KRowOptions(
                  title: 'Time Intervals',
                  layoutType: LayoutType.row,
                  children: [
                    Expanded(
                      child: KOption(
                        text: '24 Hour',
                        isSelected: _selectedTimeInterval == '24 Hour',
                        onTap: () {
                          setState(() {
                            _selectedTimeInterval = '24 Hour';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KOption(
                        text: '12 Hour',
                        isSelected: _selectedTimeInterval == '12 Hour',
                        onTap: () {
                          setState(() {
                            _selectedTimeInterval = '12 Hour';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                KRowOptions(
                  title: 'Scene Select',
                  layoutType: LayoutType.row,
                  children: [
                    Expanded(
                      child: KOption(
                        text: 'Forest Scene',
                        isSelected: _selectedScene == 'Forest Scene',
                        onTap: () {
                          setState(() {
                            _selectedScene = 'Forest Scene';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KOption(
                        text: 'Sea Scene',
                        isSelected: _selectedScene == 'Sea Scene',
                        onTap: () {
                          setState(() {
                            _selectedScene = 'Sea Scene';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: KButton(
              text: 'Share Weather',
              onPressed: () {
              },
              rightIcon: Icons.send,
            ),
          ),
          if (_controller.value.isInitialized)
            Container(
              height: 200, 
              child: Stack(
                children: [
                  Positioned(
                    left: -10,
                    bottom: 10,
                    child: Container(
                      width: 400,
                      height: 100, 
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width * 0.5,
                          height: _controller.value.size.height* 0.5,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
