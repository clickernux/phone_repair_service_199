import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/util.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return StreamBuilder(
        stream: firestore
            .collection(Util.collectionNameMessage)
            .orderBy('timestamp', descending: true)
            .snapshots(),
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
                onLongPress: FirebaseAuth.instance.currentUser == null
                    ? null
                    : () => deleteNoti(context, doc.id),
                leading: const Icon(LineIcons.bullhorn),
                title: Text(doc.data()['message']),
                subtitle: Text(formattedDate),
              );
            },
          );
        });
  }

  void deleteNoti(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: const Icon(Icons.cancel),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.done),
            ),
          ],
          content: const Text('Delete this notification?'),
          title: const Text('Warning!'),
          icon: const Icon(Icons.warning),
        );
      },
    ).then((value) {
      if (value != true) {
        debugPrint('Do not delete the noti!');
      } else {
        debugPrint('Delete the noti!');
        FirebaseFirestore.instance
            .collection(Util.collectionNameMessage)
            .doc(id)
            .delete()
            .onError((error, stackTrace) => _errorDeletingNoti(context, error))
            .then((value) => _doneDeletingNoti(context));
      }
    });
  }

  void _errorDeletingNoti(BuildContext context, Object? error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void _doneDeletingNoti(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Deleted!')));
  }
}
