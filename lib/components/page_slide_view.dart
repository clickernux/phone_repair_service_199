import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';

import 'component_layer.dart';
import 'page_indicator.dart';

class PageSlideView extends StatefulWidget {
  const PageSlideView({super.key});

  @override
  State<PageSlideView> createState() => _PageSlideViewState();
}

class _PageSlideViewState extends State<PageSlideView> {
  late final PageController _pageController;
  late final FirebaseFirestore _firestore;
  late final StreamController<int> _streamController;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _pageController = PageController(initialPage: 0, viewportFraction: 1.5);
    _streamController = StreamController<int>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _streamController.close();
    super.dispose();
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
            for (var doc in data.docs) {
              debugPrint(doc.data().toString());
            }

            final latestData = data.docs;
            return Column(
              children: [
                Expanded(
                  flex: 10,
                  child: PageView.builder(
                    itemCount: latestData.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final doc = latestData[index];
                      final List<dynamic> imgUrl = doc.data()['imgList'];
                      debugPrint(imgUrl.first.toString());
                      return PageCard(imgUrl: imgUrl, doc: doc);
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: PageIndicator(
                    streamController: _streamController,
                    latestData: latestData,
                  ),
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
    _streamController.add(value);
  }
}
