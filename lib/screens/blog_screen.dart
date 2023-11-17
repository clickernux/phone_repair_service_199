import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/model/blogger_post.dart';
import 'package:phone_repair_service_199/util.dart';

import '../components/component_layer.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဖတ်စရာများ'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.heartAlt),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox(Util.bloggerPost),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'ဖတ်စရာများ ရယူရန် ပြဿနာရှိနေသည်။\nအင်တာနက်ဖွင့်ထားပါ!',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.8),
              ),
            ),
          );
        }
        final data = snapshot.data?.toMap();
        if (data == null || data.isEmpty) {
          return const Center(
            child: Text('No Data'),
          );
        }
        debugPrint(data.toString());
        final posts = data.values.toList();
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = BloggerPost.fromJson(posts[index]);

            return BlogCard(blog: blog);
          },
        );
        // return const Center(
        //   child: Text("Data Exist!"),
        // );
      },
    );
  }
}
