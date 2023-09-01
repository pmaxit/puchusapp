
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class PostCard extends StatelessWidget{
  final Post post;
  const PostCard({
    super.key,
    required this.post
  });
  @override
  Widget build(Object context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            PostHeader(post: post),
            const SizedBox(height: 10.0,),
            Text(post.caption!),
            post.imageUrl != null ? const SizedBox.shrink() : const SizedBox(height: 10.0,),
          ]),

          post.imageUrl != null ? CachedNetworkImage(imageUrl: post.imageUrl!): const SizedBox.shrink(),

          const SizedBox(height: 10.0,),
          const PostStats(),
        ],

      )
    );
  }
}

class PostStats  extends StatelessWidget {
  const PostStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: const Icon(Icons.thumb_up, color: Colors.white, size: 12.0,),),
                const SizedBox(width: 5.0,),
                Text('2.5K', style: TextStyle(color: Colors.grey[600], fontSize: 12.0),)
              ],),
              Row(children: [
                Text('400 comments', style: TextStyle(color: Colors.grey[600], fontSize: 12.0),),
                const SizedBox(width: 5.0,),
                Text('100 shares', style: TextStyle(color: Colors.grey[600], fontSize: 12.0),)
              ],),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(onPressed: (){}, icon:  Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[600],), label: Text('Like', style: TextStyle(color: Colors.grey[600]),)),
              TextButton.icon(onPressed: (){}, icon:  Icon(Icons.comment_outlined, color: Colors.grey[600],), label: Text('Comment', style: TextStyle(color: Colors.grey[600]),)),
              TextButton.icon(onPressed: (){}, icon:  Icon(Icons.share_outlined, color: Colors.grey[600],), label: Text('Share', style: TextStyle(color: Colors.grey[600]),)),
            ],
          )
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final Post post;
  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ProfileAvatar(imageUrl: "https://i.pravatar.cc/300"),
      const SizedBox(width: 10.0,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.user.name ?? "User Name"),
            Row(
              children: [
                Text('${post.timeAgo} • ', style: TextStyle(color: Colors.grey[600], fontSize: 12.0),),
                Icon(Icons.public, color: Colors.grey[600], size: 12.0,)
              ]
            )
          ]
        )
      ),
      IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))
   ],);
  }
}

class ProfileAvatar extends StatelessWidget{
  final String imageUrl;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context){

    // circular avatar
    return CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.grey[200],
      backgroundImage: CachedNetworkImageProvider(imageUrl),
    );
  }
}