import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:farra_app/pages/trip_form_page.dart'; // ✅ استيراد الصفحة الثانية

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class FarraApp extends StatelessWidget {
  const FarraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farra',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/trip': (context) => TripFormPage(), // ✅ صفحة البيانات
      },
    );
  }
}