import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/load_json.dart';

import '../components/component_layer.dart';

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: LoadJson.ussdCodes(operatorName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Center(child: Text('No Data'));
        }

        return ListView.builder(
          itemCount: data.length,
          primary: true,
          itemBuilder: (context, index) {
            final code = data[index];

            return UssdTile(ussd: code);
          },
        );
      },
    );
  }
}
