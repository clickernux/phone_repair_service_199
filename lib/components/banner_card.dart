import 'package:flutter/material.dart';

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
