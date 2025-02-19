import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:weather_wise/core/api/weather_api.dart';
import 'package:weather_wise/main.dart';
import 'package:weather_wise/shared/utils/permissions_utils.dart';
import 'package:weather_wise/shared/utils/message_utils.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'weather_report_card.dart';
import 'k_option.dart';
import 'k_row_options.dart';
import 'k_button.dart';
import '../core/database/database_helper.dart';
import '../core/cubit/weather_cubit.dart';
import 'package:weather_wise/core/service_locator.dart';
import 'package:weather_wise/core/api/location_api.dart';

class KDrawer extends StatefulWidget {
  const KDrawer({Key? key}) : super(key: key);

  @override
  _KDrawerState createState() => _KDrawerState();
}

class _KDrawerState extends State<KDrawer> {
  late VideoPlayerController _controller;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final LocationApi _locationApi = LocationApi();
  List<Map<String, dynamic>> _savedLocations = [];
  late WeatherCubit _weatherCubit;
  final GlobalKey _cardKey = GlobalKey();
  String title = getGreetingMessage();
  String quote = getQuote();

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

    _loadSavedLocations();
  }

  Future<void> _saveUnit(String unit) async {
    await _databaseHelper.saveUnit(unit);
    _weatherCubit.changeUnit(unit == '°C' ? 'metric' : 'imperial');
    setState(() {});

    final latLon = await _locationApi
        .getLatLonFromDisplayName(_weatherCubit.selectedLocation);
    _weatherCubit.fetchWeather(latLon['lat']!, latLon['lon']!);

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
    setState(() {});

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
  }

  Future<void> _saveScene(String scene) async {
    _weatherCubit.changeScene(scene);

    setState(() {
      _weatherCubit.selectedScene = scene;
    });
  }

  Future<void> _shareWeather() async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/weather.png').create();
      await file.writeAsBytes(pngBytes);

      Share.shareXFiles([XFile(file.path)], text: 'Check out the weather!');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Drawer(
      backgroundColor:
          themeNotifier.isDarkMode ? Colors.grey[850] : Colors.white,
      child: Stack(
        children: [
          // I render this at the back of the drawer that i can reference it when sharing the weather
          WeatherReportCard(
            cardKey: _cardKey,
          ),

          // Main content
          Column(
            children: [
              Expanded(
                child: Container(
                  color: themeNotifier.isDarkMode
                      ? Colors.grey[850]
                      : Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        color: themeNotifier.isDarkMode
                            ? Colors.black
                            : Colors.blueGrey,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              quote,
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
                              isSelected: !themeNotifier.isDarkMode,
                              onTap: () {
                                themeNotifier.toggleTheme('Light');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: KOption(
                              text: 'Dark',
                              isSelected: themeNotifier.isDarkMode,
                              onTap: () {
                                themeNotifier.toggleTheme('Dark');
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
                            isSelected: _weatherCubit.selectedLocation ==
                                'Current Location',
                            onTap: () {
                              _setActiveLocation('Current Location');
                            },
                          ),
                          ..._savedLocations.map((location) {
                            return Column(
                              children: [
                                SizedBox(height: 8),
                                KOption(
                                  text: location['display_name'],
                                  isSelected: _weatherCubit.selectedLocation ==
                                      location['display_name'],
                                  onTap: () {
                                    _setActiveLocation(
                                        location['display_name']);
                                  },
                                  rightIcon: Icons.close,
                                  onRightIconPress: () {
                                    _deleteLocation(location['id']);
                                  },
                                ),
                              ],
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
                              isSelected: _weatherCubit.unit == 'metric',
                              onTap: () {
                                _saveUnit('°C');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: KOption(
                              text: '°F',
                              isSelected: _weatherCubit.unit == 'imperial',
                              onTap: () {
                                _saveUnit('°F');
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
                              isSelected:
                                  _weatherCubit.selectedScene == 'Forest Scene',
                              onTap: () {
                                _saveScene('Forest Scene');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: KOption(
                              text: 'Sea Scene',
                              isSelected:
                                  _weatherCubit.selectedScene == 'Sea Scene',
                              onTap: () {
                                _saveScene('Sea Scene');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KButton(
                              mainAxisSize: MainAxisSize.max,
                              text: 'Share Weather',
                              onPressAsync: _shareWeather,
                              rightIcon: Icons.wechat,
                            ),
                            const SizedBox(height: 16),
                            KButton(
                              mainAxisSize: MainAxisSize.max,
                              text: 'Weather Detective',
                              onPressed: () {
                                Navigator.pushNamed(context, '/detective');
                              },
                              rightIcon: Icons.keyboard_option_key,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
