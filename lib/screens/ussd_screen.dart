import 'package:flutter/material.dart';

class UssdScreen extends StatelessWidget {
  const UssdScreen({
    super.key,
    required this.operatorName,
  });
  final String operatorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operatorName),
      ),
      body: const Placeholder(),
    );
  }
}
