import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/trip_form_page.dart';

class SplashScreen extends StatefulWidget {
  final bool enableTimer;
  const SplashScreen({super.key, this.enableTimer = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.enableTimer) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => TripFormPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
     backgroundColor: const Color(0xFF090A0F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار الجديد في الأعلى
              Image.asset(
                'assets/new_logo.png',
                width: 320,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
