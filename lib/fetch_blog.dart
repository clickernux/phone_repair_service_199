import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:phone_repair_service_199/model/data_layer.dart';

class FetchBlog {
  static Future<List<BloggerPost>> fetchBlog(
      String blogId, String apiKey) async {
    final String url =
        'https://www.googleapis.com/blogger/v3/blogs/$blogId/posts?key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final List<BloggerPost> posts = [];
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> haha = data['items'];
      for (var element in haha) {
        final id = element['id'];
        final title = element['title'];
        final content = element['content'];
        final date = element['published'];
        final url = element['selfLink'];
        final bloggerPost = BloggerPost(
          id: id,
          title: title,
          content: content,
          date: date,
          selfLink: url,
        );
        posts.add(bloggerPost);
      }
    } else {
      Future.error('Unable to fetch blogger data');
    }

    return posts;
  }

  static String imgUrl(String htmlContent) {
    final doc = parse.parse(htmlContent);
    final imgElement = doc.querySelector('img');

    if (imgElement != null && imgElement.attributes.containsKey('src')) {
      return imgElement.attributes['src']!;
    }
    return '';
  }

  static String getFirstParagraph(String htmlContent) {
    final doc = parse.parse(htmlContent);
    final result = doc.querySelector('p');

    if (result != null) {
      return result.text;
    } else {
      return '';
    }
  }
}
