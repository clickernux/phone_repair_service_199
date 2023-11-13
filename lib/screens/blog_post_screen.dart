import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';

class BlogPostScreen extends StatelessWidget {
  const BlogPostScreen({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
  final String id;
  final String title;
  final String content;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဖတ်စရာ'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.heart),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.share),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              height: 1.8,
            ),
          ),
          Flexible(child: Html(data: content))
        ],
      ),
    );
  }
}
