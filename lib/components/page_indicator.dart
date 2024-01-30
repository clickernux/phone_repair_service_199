import 'dart:async';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required Stream<int> streamController,
    required this.length,
  }) : _stream = streamController;

  final Stream<int> _stream;
  final int length;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _stream,
        initialData: 0,
        builder: (context, snapshot) {
          final pageIndex = snapshot.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(length, (index) {
              final color = pageIndex == index
                  ? Theme.of(context).colorScheme.onBackground
                  : Theme.of(context).colorScheme.onInverseSurface;
              return Padding(
                padding: const EdgeInsets.all(4.0),
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
