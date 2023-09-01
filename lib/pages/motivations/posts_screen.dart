import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';

import '../../bloc/app_state_provider.dart';
import '../../models/post_model.dart';
import 'post_card.dart';
import 'story_container.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: CustomScrollView(
        slivers:[
          SliverAppBar(
            
            leading: IconButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }, 
              icon: const Icon(Icons.arrow_back, color: Colors.white)
            ),

            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: const Text('Motivation'),
            floating: true,
            actions: [
              IconButton(onPressed: (){ 
              
              }, icon: const Icon(Icons.search, color: Colors.white))
            ]
          ),

          const SliverToBoxAdapter(
            child: StoryContainer()
          ),

          const PostsContainer()

          
        ]
      )
    );
  }

}


class PostsContainer extends HookConsumerWidget {
  const PostsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(firebaseDBProvider).postsStream();
    
    return StreamBuilder(
      stream: posts,
      builder: (context, AsyncSnapshot<List<Future<Post>>> snapshot){
        if(snapshot.hasData){
          final posts = snapshot.data;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index){
                return FutureBuilder(
                  future: posts[index],
                  builder: (context, AsyncSnapshot<Post> snapshot){
                    if(snapshot.hasData){
                      final post = snapshot.data;
                      return PostCard(post: post!);
                    }else{
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                );
              }, childCount: posts!.length
            )
          );
        }
        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
      }
    );
  }

    
}
