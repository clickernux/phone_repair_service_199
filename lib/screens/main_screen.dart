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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ကျွမ်းကျင်မှုဖြင့်သာ ဝန်ဆောင်မှုပေးသည်',
                  style: textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                const BannerScroll(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: ,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverGrid.count(
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.blue,
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.black38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
