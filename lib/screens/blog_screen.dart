import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';

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
    final textTheme = Theme.of(context).textTheme;

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
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = data[index];
            final imgUrl = FetchBlog.imgUrl(blog.content);
            final brief = FetchBlog.getFirstParagraph(blog.content);

            // return ListTile(
            //   leading: SizedBox(
            //     width: 100,
            //     child: imgUrl.isEmpty
            //         ? Image.asset(
            //             'assets/images/repair_phone.jpg',
            //             fit: BoxFit.cover,
            //           )
            //         : SizedBox(
            //             width: 100,
            //             child: CachedNetworkImage(
            //               imageUrl: imgUrl,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //   ),
            //   title: Text(
            //     blog.title,
            //   ),
            //   subtitle: Text(
            //     brief,
            //     maxLines: 2,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            //   titleTextStyle: textTheme.labelLarge?.copyWith(fontSize: 18),
            //   // subtitleTextStyle: textTheme.labelLarge,
            // );
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    style: textTheme.labelLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
