import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/screens/screen_layer.dart';

void main() {
  runApp(const PhoneRepairService199App());
}

class PhoneRepairService199App extends StatelessWidget {
  const PhoneRepairService199App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainScreen(),
    );
  }
}
