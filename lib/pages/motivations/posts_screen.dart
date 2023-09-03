import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';

import '../../bloc/app_state_provider.dart';
import '../../models/post_model.dart';
import 'post_card.dart';
import 'story_container.dart';

class PostsScreen extends StatelessWidget {
  final double minHeight = 80;
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GestureDetector(
        // opaque
        behavior:  HitTestBehavior.opaque ,
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers:[
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: true,
              primary: true,
              collapsedHeight: minHeight,
              title: titleWidget(),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.deepOrange,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
      
            const SliverToBoxAdapter(
              child: StoryContainer()
            ),
      
            const PostsContainer()
      
            
          ]
        ),
      )
    );
  }
    Widget titleWidget() {
    return const Text(
      'Motivation',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
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
