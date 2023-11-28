import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/util.dart';

class AllNotificationScreen extends StatelessWidget {
  const AllNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('အသိပေးချက်များ'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return FutureBuilder(
        future: firestore
            .collection(Util.collectionNameMessage)
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('အသိပေးချက်များ ရယူရာတွင် ပြဿနာရှိနေသည်!'),
              ),
            );
          }
          final data = snapshot.data;
          if (data == null || data.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('အသိပေးချက်များ မရှိသေးပါ!'),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              final Timestamp rawDate = (doc.data()['timestamp']);
              final DateTime date = rawDate.toDate();
              final formattedDate =
                  DateFormat('dd/MM/yyyy, hh:mm:ss aa').format(date);
              return ListTile(
                leading: const Icon(LineIcons.bullhorn),
                title: Text(doc.data()['message']),
                subtitle: Text(formattedDate),
              );
            },
          );
        });
  }
}
