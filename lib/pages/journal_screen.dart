import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/models/models.dart';

import '../bloc/app_state.dart';
import 'widgets/post_card.dart';
import 'widgets/post_container.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: CustomScrollView(
        slivers:[
          SliverAppBar(
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
            child: PostContainer()
          ),

          PostsContainer()

          
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
    final posts = ref.watch(appStateProvider.notifier.select((value) => value.posts,));
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index){
          return PostCard(post: posts[index]);
        },
        childCount: posts.length
      )
    );
  }

    
}
