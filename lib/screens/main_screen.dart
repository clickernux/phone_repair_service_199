import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Util.appNameMM),
            const Text(
              'ကျွမ်းကျင်မှုဖြင့်သာ ဝန်ဆောင်မှုပေးသည် ..',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.labelLarge,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return const Placeholder();
  }
}
