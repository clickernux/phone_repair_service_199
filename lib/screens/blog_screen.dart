import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';

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
    final apiKey = dotenv.env['BLOGGER_API'] ?? '';
    return FutureBuilder(
      future: FetchBlog.fetchBlog('683508182780079242', apiKey),
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
