import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';
import 'package:phone_repair_service_199/util.dart';

class ActivitySlideHost extends StatelessWidget {
  const ActivitySlideHost({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return StreamBuilder(
      stream: firestore
          .collection(Util.collectionName)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error Fetching Activity Data'),
          );
        }
        final data = snapshot.data;
        if (data == null || data.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        return ActivitySlideshow(data: data.docs);
      },
    );
  }
}
