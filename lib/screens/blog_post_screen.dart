import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/model/data_layer.dart';
import 'package:phone_repair_service_199/util.dart';
import 'package:share_plus/share_plus.dart';

class BlogPostScreen extends StatefulWidget {
  const BlogPostScreen({super.key, required this.post});

  final BloggerPost post;

  @override
  State<BlogPostScreen> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  bool _isFav = false;
  late final Box box;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဖတ်စရာ'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isFav) {
                  box.delete(widget.post.id);
                  _isFav = false;
                } else {
                  box.put(widget.post.id, widget.post.toJson());
                  _isFav = true;
                }
              });
            },
            icon: Icon(_isFav ? LineIcons.heartAlt : LineIcons.heart),
          ),
          IconButton(
            onPressed: () {
              Share.share(widget.post.url);
            },
            icon: const Icon(LineIcons.share),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = DateTime.parse(widget.post.date);
    debugPrint('Date: ${date.day}-${date.month}-${date.year}');

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
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const Divider(
          indent: 12,
          endIndent: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            DateFormat('dd-MMM-yyyy').format(date),
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Html(data: widget.post.content)
      ],
    );
  }

  void _initializeBox() async {
    box = await Hive.openBox(Util.savedPosts);
    if (box.containsKey(widget.post.id)) {
      setState(() {
        _isFav = true;
      });
    }
  }
}
