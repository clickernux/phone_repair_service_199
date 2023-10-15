import 'package:cloud_firestore/cloud_firestore.dart';

class SlideData {
  final String title;
  final String content;
  final List<String> imgUrlList;

  SlideData({this.title = '', this.content = '', this.imgUrlList = const []});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imgList': imgUrlList,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
