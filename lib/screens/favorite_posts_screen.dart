import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phone_repair_service_199/util.dart';

import '../components/component_layer.dart';
import '../model/data_layer.dart';

class FavoritePostsScreen extends StatelessWidget {
  const FavoritePostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('သိမ်းထားသည့် ဖတ်စရာများ'),
        titleTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: Hive.openBox(Util.savedPosts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'ဖတ်စရာများ ရယူရန် ပြဿနာရှိနေသည်။',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.8),
              ),
            ),
          );
        }
        final data = snapshot.data?.toMap();
        if (data == null || data.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('ဖတ်ရန် သိမ်းထားသည်များ မရှိပါ'),
            ),
          );
        }
        debugPrint('Post List: ${data.length}');
        final posts = data.values.toList();
        posts.sort((a, b) {
          final DateTime aDate = DateFormat('yyyy-MM-dd').parse(a['date']);
          final DateTime bDate = DateFormat('yyyy-MM-dd').parse(b['date']);
          return bDate.compareTo(aDate);
        });
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = BloggerPost.fromJson(posts[index]);

            return BlogCard(blog: blog);
          },
        );
      },
    );
  }
}
