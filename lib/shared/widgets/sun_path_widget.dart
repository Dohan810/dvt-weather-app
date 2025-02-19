import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_wise/features/weather/weather_report.func.dart';
import '../../core/models/weather_model.dart';

class SunPathWidget extends StatelessWidget {
  final WeatherModel weatherData;

  const SunPathWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(weatherData.sunrise * 1000);
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(weatherData.sunset * 1000);
    // Use a static time for testing
    final currentTime = DateTime.now();

    final totalDaylight = sunsetTime.difference(sunriseTime).inMinutes;
    final elapsedDaylight = currentTime.difference(sunriseTime).inMinutes;
    final sunPosition = (elapsedDaylight / totalDaylight).clamp(0.0, 1.0);

    final isNight = currentTime.isBefore(sunriseTime) || currentTime.isAfter(sunsetTime);

    return Container(
      color: getBackgroundColor(),
      height: 200,
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              children: [
                const Text('Sun Rise', style: TextStyle(color: Colors.white)),
                Text(DateFormat('hh:mm a').format(sunriseTime), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                const Text('Sun Set', style: TextStyle(color: Colors.white)),
                Text(DateFormat('hh:mm a').format(sunsetTime), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: SunPathPainter(sunPosition, isNight),
          ),
        ],
      ),
    );
  }
}

class ParabolicPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SunPathPainter extends CustomPainter {
  final double sunPosition;
  final bool isNight;

  SunPathPainter(this.sunPosition, this.isNight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    canvas.drawPath(path, paint);

    final point = _calculateQuadraticBezierPoint(
      sunPosition,
      Offset(0, size.height),
      Offset(size.width / 2, 0),
      Offset(size.width, size.height),
    );

    final sunPaint = Paint()
      ..color = isNight ? Colors.grey : const Color.fromARGB(255, 255, 115, 0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 24, sunPaint);
  }

  Offset _calculateQuadraticBezierPoint(
      double t, Offset p0, Offset p1, Offset p2) {
    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant SunPathPainter oldDelegate) {
    return oldDelegate.sunPosition != sunPosition ||
        oldDelegate.isNight != isNight;
  }
}
