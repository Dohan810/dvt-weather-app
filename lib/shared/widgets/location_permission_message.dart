import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_wise/shared/widgets/k_add_space.dart';
import 'package:weather_wise/shared/widgets/k_button.dart';
import 'package:weather_wise/shared/utils/permissions_utils.dart';

class LocationPermissionMessage extends StatelessWidget {
  final VoidCallback? onLocationApproved;

  const LocationPermissionMessage({
    super.key,
    this.onLocationApproved,
  });

  void _openSettings() async {
    await Geolocator.openAppSettings();
    // Check location status after settings change
    final isEnabled = await PermissionsUtils.checkLocationStatus();
    if (isEnabled && onLocationApproved != null) {
      onLocationApproved!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_disabled,
            size: 64,
            color: Colors.red,
          ),
          const KAddSpace(multiplier: 4),
          Text(
            "Location Permission Required",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const KAddSpace(multiplier: 2),
          Text(
            "Please enable location services to use this app",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const KAddSpace(multiplier: 6),
          KButton(text: 'Open Settings', onPressed: _openSettings),
        ],
      ),
    );
  }
}
