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
import 'package:weather_wise/core/api/location_api.dart';

class KDrawer extends StatefulWidget {
  const KDrawer({Key? key}) : super(key: key);

  @override
  _KDrawerState createState() => _KDrawerState();
}

class _KDrawerState extends State<KDrawer> {
  late VideoPlayerController _controller;
  String _selectedUnit = '°C';
  String _selectedTimeInterval = '24 Hour';
  String _selectedScene = 'Forest Scene';
  String _selectedTheme = 'Light';
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final LocationApi _locationApi = LocationApi();
  List<Map<String, dynamic>> _savedLocations = [];
  late WeatherCubit _weatherCubit;

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
    _weatherCubit = getIt<WeatherCubit>();
    _loadSettings();
    _loadSavedLocations();
  }

  Future<void> _loadSettings() async {
    final unit = await _databaseHelper.getUnit();
    if (unit != null) {
      setState(() {
        _selectedUnit = unit;
      });
      _weatherCubit.unit = unit == '°C' ? 'metric' : 'imperial';
    }
  }

  Future<void> _saveUnit(String unit) async {
    await _databaseHelper.saveUnit(unit);
    _weatherCubit.changeUnit(unit == '°C' ? 'metric' : 'imperial');
    _weatherCubit.fetchWeather(-26.086244, 27.960827);
  }

  Future<void> _loadSavedLocations() async {
    final locations = await _locationApi.getSavedLocations();
    setState(() {
      _savedLocations = locations;
    });
  }

  Future<void> _deleteLocation(int id) async {
    await _locationApi.deleteLocation(id);
    _loadSavedLocations();
  }

  Future<void> _setActiveLocation(String displayName) async {
    _weatherCubit.setSelectedLocation(displayName);
    // Fetch weather for the selected location
    if (displayName == 'Current Location') {
      final position = await PermissionsUtils.getCurrentLocation();
      if (position != null) {
        _weatherCubit.fetchWeather(position.latitude, position.longitude);
      } else {
        _weatherCubit.fetchWeather(-26.086244, 27.960827);
      }
    } else {
      final latLon = await _locationApi.getLatLonFromDisplayName(displayName);
      _weatherCubit.fetchWeather(latLon['lat']!, latLon['lon']!);
    }

    setState(() {
      
    });
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
                      isSelected: _weatherCubit.selectedLocation == 'Current Location',
                      onTap: () {
                        _setActiveLocation('Current Location');
                      },
                    ),
                    ..._savedLocations.map((location) {
                      return KOption(
                        text: location['display_name'],
                        isSelected: _weatherCubit.selectedLocation == location['display_name'],
                        onTap: () {
                          _setActiveLocation(location['display_name']);
                        },
                        rightIcon: Icons.close,
                        onRightIconPress: () {
                          _deleteLocation(location['id']);
                        },
                      );
                    }).toList(),
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
          // if (_controller.value.isInitialized)
          //   Container(
          //     height: 200, 
          //     child: Stack(
          //       children: [
          //         Positioned(
          //           left: -10,
          //           bottom: 10,
          //           child: Container(
          //             width: 400,
          //             height: 100, 
          //             child: FittedBox(
          //               fit: BoxFit.cover,
          //               child: SizedBox(
          //                 width: _controller.value.size.width * 0.5,
          //                 height: _controller.value.size.height* 0.5,
          //                 child: VideoPlayer(_controller),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
