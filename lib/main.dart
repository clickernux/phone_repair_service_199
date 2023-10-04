import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/main_router.dart';

void main() {
  runApp(const PhoneRepairService199App());
}

class PhoneRepairService199App extends StatelessWidget {
  const PhoneRepairService199App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: MainRouter.router,
    );
  }
}
