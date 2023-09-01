import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/stories.dart';

class StoryContainer extends HookConsumerWidget {
  const StoryContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final stories = ref.watch(firebaseDBProvider).storiesStream();
        
      return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 20.0, backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider("https://randomwordgenerator.com/img/picture-generator/53e3d745485bad14f1dc8460962e33791c3ad6e04e507440762e7ad39449c0_640.jpg")),
              SizedBox(width: 25.0),
              Expanded(
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

          StreamBuilder(
            stream: stories,
            builder: (context, AsyncSnapshot<List<Future<Story>>> snapshot){
              if(snapshot.hasError){
                return const Center(child: Text('Something went wrong'));
              }

              if(snapshot.hasData){
                return Container(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return FutureBuilder(
                        future: snapshot.data![index],
                        builder: (context, AsyncSnapshot<Story> snapshot){
                          if(snapshot.hasData){
                            return StoryCard(story: snapshot.data!);
                          }else{
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                      );
                    }
                  ),
                );
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            }
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
              backgroundImage: CachedNetworkImageProvider("https://randomwordgenerator.com/img/picture-generator/53e3d745485bad14f1dc8460962e33791c3ad6e04e507440762e7ad39449c0_640.jpg"),
            )
          ),
    
          // text 
          Positioned(
            bottom: 8.0,
            left: 8.0,
            width: 120,
            child: Text(
              story.user.name?? "User Name",
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.0
              ),
            )
          )
    
        
        ],
      ),
    );
  }
}