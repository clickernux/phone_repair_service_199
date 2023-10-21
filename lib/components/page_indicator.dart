import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required StreamController<int> streamController,
    required this.latestData,
  }) : _streamController = streamController;

  final StreamController<int> _streamController;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> latestData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          final pageIndex = snapshot.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(latestData.length, (index) {
              final color =
                  pageIndex == index ? Colors.black87 : Colors.white60;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 5,
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 4,
                  ),
                ),
              );
            }),
          );
        });
  }
}
