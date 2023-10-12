import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';

import 'component_layer.dart';

class BannerScroll extends StatelessWidget {
  const BannerScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Util.bannerContent.length + 1,
      itemBuilder: (context, index) {
        if (index >= Util.bannerContent.length) {
          return TextButton(
              onPressed: () {}, child: const Text('ပိုမိုသိရှိရန် >>'));
        }
        final content = Util.bannerContent[index];
        return BannerCard(text: content.text, imgPath: content.imgPath);
      },
    );
  }
}
