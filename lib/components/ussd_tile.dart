import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/model/ussd.dart';

class UssdTile extends StatelessWidget {
  const UssdTile({
    super.key,
    required this.ussd,
  });

  final Ussd ussd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ussd.service,
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              // const SizedBox(height: 8),
              const Divider(),
              Text(
                ussd.code,
                style: textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
