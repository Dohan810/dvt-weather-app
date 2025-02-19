import 'package:flutter/material.dart';
import 'package:weather_wise/features/weather/weather_report.func.dart';
import 'package:weather_wise/shared/widgets/k_add_space.dart';
import '../../core/models/weather_model.dart';

class AdditionalDetailsWidget extends StatelessWidget {
  final WeatherModel weatherData;

  const AdditionalDetailsWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Details',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const KAddSpace(multiplier: 4),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildDetailTile(
                    'Wind', '${weatherData.windSpeed} km/h', Icons.air),
              ),
              const KAddSpace(multiplier: 2),
              Expanded(
                flex: 2,
                child: _buildDetailTile(
                    'Cloud Cover', '${weatherData.clouds}%', Icons.cloud),
              ),
            ],
          ),
              const KAddSpace(multiplier: 2),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDetailTile(
                    'Gusts', '${weatherData.windGust} km/h', Icons.air),
              ),
              const KAddSpace(multiplier: 2),
              Expanded(
                flex: 1,
                child: _buildDetailTile(
                    'Humidity', '${weatherData.humidity}%', Icons.water_drop),
              ),
            ],
          ),
              const KAddSpace(multiplier: 2),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildDetailTile(
                    'Pressure', '${weatherData.pressure} hPa', Icons.speed),
              ),
              const KAddSpace(multiplier: 2),
              Expanded(
                flex: 2,
                child: _buildDetailTile('Visibility',
                    '${weatherData.visibility / 1000} km', Icons.visibility),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, IconData icon) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const KAddSpace(multiplier: 1),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          const KAddSpace(multiplier: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
