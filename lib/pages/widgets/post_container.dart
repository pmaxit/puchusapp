import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/models/post_model.dart';
import 'package:oneui/models/stories.dart';

import '../../bloc/app_state.dart';

class PostContainer extends HookConsumerWidget {
  const PostContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(appStateProvider.notifier.select((value) => value.user,));
    final stories = ref.watch(appStateProvider.notifier.select((value) => value.stories,));
    final posts = ref.watch(appStateProvider.notifier.select((value) => value.posts,));
    
    print("stories $stories");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20.0, backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(currentUser!.imageUrl)),
              const SizedBox(width: 25.0),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?\n',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black38),
                    hintMaxLines: 10,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    )
                )
              )
              
            ],
          ),
          const Divider(height: 10.0, thickness: 0.5,),

          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (BuildContext context, int index){
                return StoryCard(story: stories[index]);
              }
            )
          ),
          const Divider(height: 10.0, thickness: 0.5,),

        ]
      )
      
    );
  }
}


class StoryCard extends StatelessWidget {
  final Story story;
  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0,  top: 8.0, bottom: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
         ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CachedNetworkImage(
            imageUrl: story.imageUrl,
            height: double.infinity,
            width: 130.0,
            fit: BoxFit.cover,
          ),
         ),
         Container(
          height: double.infinity,
          width: 130.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7)
              ]
            )
          ),
          ),
         
      
          // circal avatar
          Positioned(
            top: 8.0,
            left: 8.0,
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(story.user.imageUrl),
            )
          ),
    
          // text 
          Positioned(
            bottom: 8.0,
            left: 8.0,
            width: 120,
            child: Text(
              story.user.name,
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0
              ),
            )
          )
    
        
        ],
      ),
    );
  }
}