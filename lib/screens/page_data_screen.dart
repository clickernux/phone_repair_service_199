import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageDataScreen extends StatelessWidget {
  const PageDataScreen({super.key, required this.doc});
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final title = doc.data()['title'];
    final content = doc.data()['content'];
    final urlList = doc.data()['imgList'] as List<dynamic>;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: urlList.first,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Text(
              title,
              style: textTheme.headlineMedium,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Text(content),
          ),
        ),
        SliverList.builder(
          itemCount: urlList.length,
          itemBuilder: (context, index) {
            final url = urlList[index];
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 16,
                right: 16,
              ),
              child: SizedBox(
                height: 250,
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.scaleDown,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
