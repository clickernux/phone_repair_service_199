import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';

class ActivitySlideshow extends StatefulWidget {
  const ActivitySlideshow({super.key, required this.data});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  State<ActivitySlideshow> createState() => _ActivitySlideshowState();
}

class _ActivitySlideshowState extends State<ActivitySlideshow> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activities',
          style: textTheme.labelLarge,
        ),
        SizedBox(
          height: 250,
          child: _buildPageView(),
        ),
      ],
    );
  }

  _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final item = widget.data[index];
        return PageCard(doc: item);
      },
    );
  }
}
