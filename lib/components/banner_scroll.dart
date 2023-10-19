import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';

import 'component_layer.dart';

class BannerScroll extends StatefulWidget {
  const BannerScroll({super.key});

  @override
  State<BannerScroll> createState() => _BannerScrollState();
}

class _BannerScrollState extends State<BannerScroll> {
  late final Timer _timer;
  int index = 0;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      setState(() {
        index = (index + 1) % Util.bannerContent.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: _introInfo(context),
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

  Widget _introInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/repair_phone.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          // borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        // alignment: Alignment.bottomLeft,
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            Util.bannerContent[index].text,
            key: ValueKey<String>(
              Util.bannerContent[index].text,
            ),
            style: textTheme.labelMedium?.copyWith(
              color: Colors.white,
              height: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
