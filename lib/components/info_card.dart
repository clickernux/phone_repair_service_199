import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      titleTextStyle:
          textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      title: Text(title),
      subtitle: Text(desc),
    );
  }
}
