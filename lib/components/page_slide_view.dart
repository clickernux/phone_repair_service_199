import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/util.dart';

import 'component_layer.dart';

class PageSlideView extends StatefulWidget {
  const PageSlideView({super.key});

  @override
  State<PageSlideView> createState() => _PageSlideViewState();
}

class _PageSlideViewState extends State<PageSlideView>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  late final FirebaseFirestore _firestore;
  late final StreamController<int> _indicatorStreamController;
  late final Timer _timer;
  int totalPage = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _firestore = FirebaseFirestore.instance;
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    _indicatorStreamController = StreamController<int>();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < totalPage - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorStreamController.close();
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Current State: ${state.name}');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: FutureBuilder(
        future: _firestore
            .collection(Util.collectionName)
            .orderBy('timestamp', descending: true)
            .limit(5)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null || data.docs.isEmpty) {
              // TODO: Implement the following widget with Custom widget
              return const Center(
                child: Text('No Data'),
              );
            }

            final latestData = data.docs;
            totalPage = latestData.length;
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: latestData.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final doc = latestData[index];
                      final List<dynamic> imgUrl = doc.data()['imgList'];

                      return InkWell(
                        onTap: () {
                          context.goNamed(
                            'page_data',
                            extra: doc,
                          );
                        },
                        child: PageCard(imgUrl: imgUrl, doc: doc),
                      );
                    },
                  ),
                ),
                PageIndicator(
                  streamController: _indicatorStreamController,
                  latestData: latestData,
                ),
              ],
            );
          }
          return const Center(
            child: Text('Error getting data'),
          );
        },
      ),
    );
  }

  void _onPageChanged(int value) {
    debugPrint('Current Page Index: $value');
    currentPage = value;
    debugPrint('Current Index: $currentPage');
    _indicatorStreamController.add(value);
  }
}
