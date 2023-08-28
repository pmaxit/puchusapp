import 'stories.dart';

class Post{
  final User user;
  final String caption;
  final String timeAgo;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;

  Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares
  });
}

class Journal{
  final String date;
  final String title;
  final String content;
  final String timeAgo;

  Journal({
    required this.date,
    required this.title,
    required this.content,
    required this.timeAgo
  });
}