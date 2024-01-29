import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';

class ActivitySlideshow extends StatefulWidget {
  const ActivitySlideshow({super.key, required this.data});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  State<ActivitySlideshow> createState() => _ActivitySlideshowState();
}

class _ActivitySlideshowState extends State<ActivitySlideshow> {
  late final PageController _pageController;
  late final StreamController<int> _streamController;

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    _streamController = StreamController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < widget.data.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activities',
              style: textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed('activities');
              },
              child: const Text('အားလုံး >>'),
            )
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: _buildPageView(),
        ),
        SizedBox(
          width: double.infinity,
          height: 22,
          child: PageIndicator(
            streamController: _streamController.stream,
            length: widget.data.length,
          ),
        ),
      ],
    );
  }

  _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.data.length,
      onPageChanged: (value) {
        _streamController.add(value);
      },
      itemBuilder: (context, index) {
        final item = widget.data[index];
        return PageCard(
          doc: item,
          onTapItem: () {
            context.goNamed('activity', extra: item);
          },
        );
      },
    );
  }
}
