import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the next screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, '/home'); // Replace with your route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Full width
        height: MediaQuery.of(context).size.height, // Full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/welcome.png'), // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire screen
            alignment: Alignment.center, // Centers the image
          ),
        ),
      ),
    );
  }
}
