import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageCard extends StatelessWidget {
  const PageCard({
    super.key,
    required this.doc,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> imgUrl = doc.data()['imgList'];
    return InkWell(
      onTap: () {
        context.goNamed(
          'page_data',
          extra: doc,
        );
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: CachedNetworkImageProvider(imgUrl.first),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          alignment: Alignment.bottomLeft,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doc.data()['title'],
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  // Text(
                  //   doc.data()['content'],
                  //   maxLines: 3,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .labelMedium
                  //       ?.copyWith(color: Colors.white),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
