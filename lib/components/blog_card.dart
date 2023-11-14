import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';
import 'package:phone_repair_service_199/model/blogger_post.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.blog,
  });

  final BloggerPost blog;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imgUrl = FetchBlog.imgUrl(blog.content);
    final brief = FetchBlog.getFirstParagraph(blog.content);

    return Column(
      children: [
        InkWell(
          onTap: () {
            context.goNamed(
              'post',
              pathParameters: {'postId': blog.id},
              extra: blog.toJson(),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: imgUrl.isEmpty
                    ? Image.asset(
                        'assets/images/repair_phone.jpg',
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                blog.title,
                style: textTheme.labelLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                brief,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }
}
