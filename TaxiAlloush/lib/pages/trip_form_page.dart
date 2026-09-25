import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:farra_app/pages/confirmation_page.dart';

class TripFormPage extends StatefulWidget {
  @override
  _TripFormPageState createState() => _TripFormPageState();
}

class _TripFormPageState extends State<TripFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final targetGovernorateController = TextEditingController();
  final targetAreaController = TextEditingController();
  final currentAreaController = TextEditingController();
  final travelDayController = TextEditingController();
  final travelTimeController = TextEditingController();
  final peopleCountController = TextEditingController(); // ✅ جديد

  // Options
  String tripType = 'ذهاب فقط';
  String tripMode = 'خط كلية';
  String carType = 'عادية';
  bool isNowSelected = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCDE),
      appBar: AppBar(title: Text('طلب رحلة')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(nameController, 'اسم الشخص'),
              buildTextField(phoneController, 'رقم الجوال', isNumber: true),
              buildTextField(targetGovernorateController, 'المحافظة المستهدفة'),
              buildTextField(targetAreaController, 'المنطقة المستهدفة'),
              buildTextField(currentAreaController, 'المنطقة الحالية'),
              buildDropdown('نوع الرحلة', ['ذهاب فقط', 'ذهاب وإياب'], tripType,
                  (val) {
                if (val != null) setState(() => tripType = val);
              }),
              buildTimingFields(),
              buildTextField(peopleCountController, 'عدد الأشخاص',
                  isNumber: true), // ✅ جديد
              buildDropdown(
                  'نمط الرحلة', ['تكسي', 'خط كلية', 'تحميل بضائع'], tripMode,
                  (val) {
                if (val != null) setState(() => tripMode = val);
              }),
              buildDropdown('فئة السيارة', ['عادية', 'فخمة'], carType, (val) {
                if (val != null) setState(() => carType = val);
              }),
              SizedBox(height: 20),
              isLoading
                  ? Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('جاري إرسال الطلب...',
                            style: TextStyle(fontSize: 16)),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);

                          final message = '''
🚖 *طلب رحلة جديد*:

👤 الاسم: ${nameController.text}
📞 الجوال: ${phoneController.text}
📍 من: ${currentAreaController.text}
➡️ إلى: ${targetGovernorateController.text} - ${targetAreaController.text}
🗓 يوم الرحلة: ${isNowSelected ? 'حالا' : travelDayController.text}
🕒 وقت الرحلة: ${isNowSelected ? '—' : travelTimeController.text}
🔁 نوع الرحلة: $tripType
👥 عدد الأشخاص: ${peopleCountController.text}
🚚 نمط الرحلة: $tripMode
🚗 فئة السيارة: $carType
''';

                          try {
                            await sendToTelegram(message);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✅ تم إرسال الطلب بنجاح'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ConfirmationPage()),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ فشل في إرسال الطلب'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      child: Text('إرسال الطلب'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          if (isNumber && !RegExp(r'^\d+$').hasMatch(value)) {
            return 'يجب إدخال أرقام فقط';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdown(String label, List<String> options, String value,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options
            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildTimingFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text('حالا'),
          value: isNowSelected,
          onChanged: (val) {
            setState(() {
              isNowSelected = val ?? false;
            });
          },
        ),
        TextFormField(
          controller: travelDayController,
          enabled: !isNowSelected,
          decoration: InputDecoration(
            labelText: 'تفاصيل يوم الرحلة',
            border: OutlineInputBorder(),
            fillColor: isNowSelected ? Colors.grey.shade200 : null,
            filled: isNowSelected,
          ),
          validator: (value) {
            if (!isNowSelected && (value == null || value.trim().isEmpty)) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: travelTimeController,
          enabled: !isNowSelected,
          decoration: InputDecoration(
            labelText: 'تفاصيل وقت الرحلة',
            border: OutlineInputBorder(),
            fillColor: isNowSelected ? Colors.grey.shade200 : null,
            filled: isNowSelected,
          ),
          validator: (value) {
            if (!isNowSelected && (value == null || value.trim().isEmpty)) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
        ),
      ],
    );
  }
    Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> sendToTelegram(String message) async {
    final String phoneNumber = '9647874275685';

    // جلب موقع الزبون وإضافته للرسالة
    Position? position = await _getCurrentLocation();
    String fullMessage = message;

    if (position != null) {
      fullMessage += "\n📍 رابط موقعي: https://maps.google.com/?q=${position.latitude},${position.longitude}";
    }

    try {
      final Uri whatsappUrl = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(fullMessage)}',
      );

      bool launched = await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      print('تعذر فتح الواتساب: $e');
    }
  }
}
