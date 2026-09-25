import 'package:flutter/material.dart';
import 'package:farra_app/pages/trip_form_page.dart';
import 'package:flutter/services.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCDE), // ✅ خلفية بلون أصفر فاتح جداً
      appBar: AppBar(title: const Text('تأكيد الطلب')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              // ✅ شعار جديد في الأعلى
              SizedBox(
                width: screenWidth * 0.4,
                child: Image.asset('assets/new_logo.png'),
              ),

              const SizedBox(height: 5),

              // ✅ كلمة Farra بتنسيق أنيق
              Text(
                'Farra',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  color: Colors.black87,
                  fontFamily: 'FasterOne',
                ),
              ),

              const SizedBox(height: 15),

              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),

              const Text(
                'تم قبول الطلب، سيتم التواصل معك الآن',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TripFormPage()),
                  );
                },
                child: const Text('رحلة جديدة'),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop(); // يغلق التطبيق
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('إغلاق التطبيق'),
              ),
            ],
          ),
         ),
        ),
      ),
    );
  }
}
