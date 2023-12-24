class BloggerPost {
  final String id;
  final String title;
  final String content;
  final String date;
  final String url;

  const BloggerPost({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.url,
  });

  factory BloggerPost.fromJson(Map<dynamic, dynamic> map) {
    return BloggerPost(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      url: map['selfLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'selfLink': url
    };
  }
}
