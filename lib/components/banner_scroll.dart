import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';

class BannerScroll extends StatelessWidget {
  const BannerScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 320,
        child: _buildListView(context),
      ),
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

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.text, required this.imgPath});

  final String text;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 320,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(1)),
            // color: Colors.yellow,
            image:
                DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover)),
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          color: Colors.black.withOpacity(0.4),
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: textTheme.labelMedium
                ?.copyWith(color: Colors.white, height: 1.8),
          ),
        ),
      ),
    );
  }
}
