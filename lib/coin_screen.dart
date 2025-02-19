import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:weather_wise/shared/utils/color_extensions.dart';
import 'package:weather_wise/core/database/database_helper.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _setCoinPageViewed() async {
    await _databaseHelper.setCoinPageViewed();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/videos/severe_weather_sun_weather.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });

    _animationController = AnimationController(
      duration: const Duration(seconds: 1), // Faster animation
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.stop();
        }
      });

    _animationController.repeat();
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorExtension.fromHex("#fff8ed"),
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Thank You DVT',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'They gave you a free coin to use the app for LIFE!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                bottom:
                    _animation.value * MediaQuery.of(context).size.height * 0.4,
                left: MediaQuery.of(context).size.width / 2 - 100,
                child: Transform(
                  transform: Matrix4.rotationY(
                      _animation.value * 2 * 3.141592653589793),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      await _setCoinPageViewed();
                      Navigator.pushNamed(context, '/report');
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/images/coin.png', // Replace with the actual path to the coin image
                        width: 200,
                        height: 300,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
