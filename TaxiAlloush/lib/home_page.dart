import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCDE), // ✅ خلفية بلون أصفر فاتح جداً
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text(
          'Welcome to Farra',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}