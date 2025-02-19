// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';

class PermissionsUtils {
  static bool _isLocationEnabled = false;
  static Position? _lastKnownLocation;

  static bool get isLocationEnabled => _isLocationEnabled;
  static Position? get lastKnownLocation => _lastKnownLocation;

  static Future<bool> checkLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    
    _isLocationEnabled = serviceEnabled && 
        permission != LocationPermission.denied && 
        permission != LocationPermission.deniedForever;
    
    if (_isLocationEnabled) {
      _lastKnownLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    }
    
    return _isLocationEnabled;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLocationEnabled = false;
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLocationEnabled = false;
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isLocationEnabled = false;
        return null;
      }

      _isLocationEnabled = true;
      _lastKnownLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      return _lastKnownLocation;
    } catch (e) {
      _isLocationEnabled = false;
      return null;
    }
  }
}
