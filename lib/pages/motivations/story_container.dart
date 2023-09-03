import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/stories.dart';

import '../../models/models.dart';

class StoryContainer extends HookConsumerWidget {
  const StoryContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final stories = ref.watch(firebaseDBProvider).storiesStream();
    final user = ref.watch(currentUserProvider);
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    final inFocus = useState(false);

    useEffect((){

      void listen(){
        if(focusNode.hasFocus){
          inFocus.value = true;
        }else{
          inFocus.value = false;
        }
      }
      focusNode.addListener(listen);
      

      return () => focusNode.removeListener(listen);
    },[focusNode]);
        
      return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Row(
            children: [
              const CircleAvatar(radius: 20.0, backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider("https://randomwordgenerator.com/img/picture-generator/53e3d745485bad14f1dc8460962e33791c3ad6e04e507440762e7ad39449c0_640.jpg")),
              const SizedBox(width: 25.0),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind?\n',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black38),
                        hintMaxLines: 10,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        )
                    ),
                  
                    // submit
                    if(inFocus.value) Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            final post = Post(
                              caption: textController.text,
                              likes: 123,
                              comments: 123,
                              shares: 123,
                              user: user,
                              imageUrl: "https://randomwordgenerator.com/img/picture-generator/53e3d745485bad14f1dc8460962e33791c3ad6e04e507440762e7ad39449c0_640.jpg",
                              timeAgo: 'Now',
                              createdAt: Timestamp.now(),
                            );
                            ref.read(firebaseDBProvider).addPost(post).then((value) =>  textController.clear());
                          }, 
                          child: const Text('Post', style: TextStyle(color: Colors.deepOrange),)
                        )
                      ],
                    )
                  ],
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
              backgroundImage:  CachedNetworkImageProvider(story.user.imageUrl ?? UserModel.generateImageUrl()),
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