import 'package:flutter/material.dart';

class OperatorCard extends StatelessWidget {
  const OperatorCard({
    super.key,
    required this.label,
    this.color,
    required this.onTap,
  });
  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: color,
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                label,
                style: textTheme.headlineMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
