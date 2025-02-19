
import 'package:flutter/material.dart';
import 'package:weather_wise/shared/widgets/location_permission_message.dart';
import 'package:weather_wise/shared/utils/permissions_utils.dart';
import 'package:weather_wise/core/base/service_locator.dart';
import 'package:weather_wise/core/cubit/weather_cubit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _hasPermission = true;

  void _onLocationApproved() {
    final location = PermissionsUtils.lastKnownLocation;
    if (location == null) return;

    getIt<WeatherCubit>().fetchWeather(location.latitude, location.longitude);
    setState(() => _hasPermission = true);
  }

  @override
  void initState() {
    super.initState();

    if (!PermissionsUtils.isLocationEnabled) _checkPermission();
  }

  Future<void> _checkPermission() async {
    final location = await PermissionsUtils.getCurrentLocation();

    if (location == null) {
      setState(() => _hasPermission = false);
      return;
    }

    _onLocationApproved();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return LocationPermissionMessage(
        onLocationApproved: _onLocationApproved,
      );
    }

    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/gifs/dancing_palm.gif"),
          Text(
            "Loading...",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            "Please wait...",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
