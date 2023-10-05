import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/util.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(Util.appNameMM),
        titleTextStyle: textTheme.labelLarge,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.bell),
          ),
        ],
      ),
      body: _buildbody(context),
    );
  }

  _buildbody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [],
    );
  }
}
