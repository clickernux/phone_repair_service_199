import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';

import '../components/component_layer.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဖတ်စရာများ'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: FetchBlog.fetchBlog(
          '683508182780079242', 'AIzaSyA_XZ3QU09iA5ea-LedL_U9IavZdBwc4yQ'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Center(
            child: Text('No Data'),
          );
        }
        debugPrint('Total Post: ${data.length}');
        return ListView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = data[index];

            return BlogCard(blog: blog);
          },
        );
      },
    );
  }
}
