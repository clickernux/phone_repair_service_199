import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:phone_repair_service_199/util.dart';

class MarqueeText extends StatelessWidget {
  const MarqueeText({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: StreamBuilder(
        stream: db
            .collection(Util.collectionNameMessage)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null || data.docs.isEmpty) {
              return defaultMarquee(Util.defaultMarqueeText);
            }
            return defaultMarquee(data.docs.first['message']);
          }
          return defaultMarquee(Util.defaultMarqueeText);
        },
      ),
    );
  }

  Widget defaultMarquee(String text) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Marquee(
        text: text,
        blankSpace: 50,
        velocity: 30,
        textScaleFactor: 1.1,
      ),
    );
  }
}
