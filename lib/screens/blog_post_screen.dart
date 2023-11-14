import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/model/data_layer.dart';

class BlogPostScreen extends StatefulWidget {
  const BlogPostScreen({super.key, required this.post});

  final BloggerPost post;

  @override
  State<BlogPostScreen> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
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

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            widget.post.title,
            style: textTheme.headlineSmall?.copyWith(
              height: 1.8,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(
          indent: 12,
          endIndent: 12,
        ),
        Html(data: widget.post.content)
      ],
    );
  }
}
