import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/sun_shine.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
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
          Positioned(
            top: -20,
            left: -20,
            child: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 86,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: -10,
            child: Text(
              'To',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.2,
            left: 20,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Weather',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Wise',
                  style: TextStyle(
                    fontSize: 36,
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
