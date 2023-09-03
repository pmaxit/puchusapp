import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';


String getTimeAgoString(Duration difference){
  String timeAgoString = '';
  if(difference.inSeconds < 60){
    timeAgoString = '${difference.inSeconds}s';
  }else if(difference.inMinutes < 60){
    timeAgoString = '${difference.inMinutes}m';
  }else if(difference.inHours < 24){
    timeAgoString = '${difference.inHours}h';
  }else if(difference.inDays < 7){
    timeAgoString = '${difference.inDays}d';
  }else{
    timeAgoString = '${difference.inDays ~/ 7}w';
  }
  return timeAgoString;

}
class Post{
  final UserModel user;
  final String? caption;
  final String? timeAgo;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  String? documentId;
  Timestamp? createdAt;

  Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    this.documentId,
    this.createdAt,
  });

  // from Map
  factory Post.fromMap(Map<String, dynamic> data, String documentId){
    final user = UserModel.fromMap(data['user']);
    final caption = data['caption'];
    final imageUrl = data['imageUrl'];
    final likes = data['likes'] as int;
    final comments = data['comments'] as int;
    final shares = data['shares'] as int;
    final createdAt = data['createdAt']?? DateTime.now().subtract(const Duration(days: 7));

    // find timeAgo from createdAt
    final now = DateTime.now();
    final postCreated = createdAt.toDate();
    final difference = now.difference(postCreated);
    final timeAgoString = getTimeAgoString(difference);

    return Post(
      user: user,
      caption: caption,
      timeAgo: timeAgoString,
      imageUrl: imageUrl,
      likes: likes,
      comments: comments, 
      shares: shares,
      documentId: documentId,
      createdAt: createdAt
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
      'shares': shares,
      'createdAt': createdAt
    };
  }
}

class Journal{
  final UserModel user;
  final String date;
  final String title;
  final String content;
  final String timeAgo;
  final String space;
  String? documentId;
  final Timestamp createdAt;
  final bool pinned;
  final int position;

  Journal({
    required this.user,
    required this.date,
    required this.title,
    required this.content,
    required this.timeAgo,
    required this.space,
    this.documentId,
    required this.createdAt,
    this.pinned = false,
    this.position = 0
  });


  String getDateinMMDDFormat(){
    final date = createdAt.toDate();
    // timestamp
    
    
    final month = date.month;   
    final day = date.day;
    final year = date.year;
    return '$month/$day/$year';

    
  }

  //FromMap
  factory Journal.fromMap(Map<String, dynamic> data, String documentId){
    final date = data['date'];
    final title = data['title'];
    final content = data['content'];
    final space = data['space'];
    final createdAt = data['createdAt']?? Timestamp.now();
    final position = data['position']?? 0;
    final pinned = data['pinned']?? false;

    // calculate tiemAgo
    final now = DateTime.now();
    final journalCreated = createdAt.toDate();
    final difference = now.difference(journalCreated);
    final timeAgo = getTimeAgoString(difference);
    

    return Journal(
      user: UserModel.fromMap(data['user']),
      date: date,
      title: title,
      content: content,
      timeAgo: timeAgo,
      documentId: documentId,
      space: space,
      createdAt: createdAt,
      pinned: pinned,
      position: position
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
      'space': space,
      'createdAt': createdAt,
      'pinned': pinned,
      'position': position,

    };
  }
}