import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';
import 'package:phone_repair_service_199/util.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(Util.appNameMM),
        titleTextStyle: textTheme.labelLarge?.copyWith(fontSize: 18),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.bell),
          ),
        ],
      ),
      body: _buildbody(context, textTheme),
    );
  }

  _buildbody(BuildContext context, TextTheme textTheme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'ကျွမ်းကျင်မှုဖြင့်သာ ဝန်ဆောင်မှုပေးသည်',
                  style: textTheme.labelSmall,
                ),
              ),
              const BannerScroll(),
            ],
          ),
        )
      ],
    );
  }
}
