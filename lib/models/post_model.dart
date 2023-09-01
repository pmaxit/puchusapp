import 'user_model.dart';

class Post{
  final UserModel user;
  final String? caption;
  final String? timeAgo;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  String? documentId;

  Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    this.documentId
  });

  // from Map
  factory Post.fromMap(Map<String, dynamic> data, String documentId){
    final user = UserModel.fromMap(data['user']);
    final caption = data['caption'];
    final timeAgo = data['timeAgo'];
    final imageUrl = data['imageUrl'];
    final likes = data['likes'] as int;
    final comments = data['comments'] as int;
    final shares = data['shares'] as int;

    return Post(
      user: user,
      caption: caption,
      timeAgo: timeAgo,
      imageUrl: imageUrl,
      likes: likes,
      comments: comments,
      shares: shares,
      documentId: documentId
    );
  }

  // toMap
  Map<String, dynamic> toMap(){
    return {
      'user': user.uid,
      'caption': caption,
      'timeAgo': timeAgo,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares
    };
  }
}

class Journal{
  final UserModel user;
  final String date;
  final String title;
  final String content;
  final String timeAgo;
  String? documentId;

  Journal({
    required this.user,
    required this.date,
    required this.title,
    required this.content,
    required this.timeAgo,
    this.documentId
  });



  //FromMap
  factory Journal.fromMap(Map<String, dynamic> data, String documentId){
    final date = data['date'];
    final title = data['title'];
    final content = data['content'];
    final timeAgo = data['timeAgo'];
    

    return Journal(
      user: UserModel.fromMap(data['user']),
      date: date,
      title: title,
      content: content,
      timeAgo: timeAgo,
      documentId: documentId
    );
  }

  // tomap
  Map<String, dynamic> toMap(){
    return {
      'date': date,
      'title': title,
      'content': content,
      'timeAgo': timeAgo,
      'user': user.uid,
      'documentId': documentId
    };
  }
}