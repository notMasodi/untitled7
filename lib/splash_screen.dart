import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:untitled7/home_page.dart';
import 'login_page.dart';

const Color color1 = Color(0xFF7469B6); // Top color
const Color color2 = Color(0xFF9D8FD1); // Second color
const Color color3 = Color(0xFFBCA1E6); // Third color
const Color color4 = Color(0xFFF5C967); // Bottom color
const Color color5 = Color(0xFFEE388A); // Bottom color

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _controller?.forward();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to EventPerfect',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'ShadeBlue', // Apply the custom font
                color: color1,
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _animation!,
              child: ScaleTransition(
                scale: _animation!,
                child: Image.asset('assets/event_logo.png', height: 400),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Where Imagination meets Celebration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Mefikademo', // Apply the custom font
                color: color1,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color2),
            ),
          ],
        ),
      ),
    );
  }
}


