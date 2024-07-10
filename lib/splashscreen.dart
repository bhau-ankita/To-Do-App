import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_app_4/taskscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Example: Simulate an initialization process before navigating to the main app screen
    _simulateInitProcess();
  }

  void _simulateInitProcess() {
    // Simulate a delay of 3 seconds before navigating to the main app screen
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                TaskScreen()), // Replace with your main app widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // You can set your preferred background color
      body: Center(
        child: Image.asset(
            'assets/images/To-Do-App-Logo.png'), // Replace with your splash screen image
      ),
    );
  }
}
