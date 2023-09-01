import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/app_state_provider.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/post_model.dart';

import '../../data/data.dart';
import '../../models/api.dart';


class NotesPage extends HookConsumerWidget {
  const NotesPage({super.key});
  final double minHeight = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final journals = ref.watch(journalsProvider);
    //final currentUser = ref.read(currentUserProvider);
    
    // useEffect((){
    //   for(var user in onlineUsers){
    //     ref.read(firebaseDBProvider).addUser(user);
    //   }
    //   ref.read(firebaseDBProvider).addUser(currentUser);

    //   for(var post in posts){
    //     ref.read(firebaseDBProvider).addPost(post);
    //   }

    //   for(var story in stories){
    //     ref.read(firebaseDBProvider).addStory(story);
    //   }

    //   for(var song in songs(currentUser)){
    //     ref.read(firebaseDBProvider).addSong(song);
    //   }
      

    //   return null;
    // },[]);


    final listView = useState(true);

    return Scaffold(
        // floating action button
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, '/create_notes');
          },
          backgroundColor: Colors.deepOrange,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            slivers: [
              // SliverPersistentHeader(
              //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
              //   pinned: true,
              // ),
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

              journals.when(
                  data: (data) {
                    if (listView.value) {
                      return journalListView(data);
                    } else {
                      return journalGridView(data);
                    }

                  },
                  loading: () => const SliverToBoxAdapter(
                          child: Center(
                        child: CircularProgressIndicator(),
                      )),
                  error: (error, stackTrace) => SliverToBoxAdapter(
                          child: Center(
                        child: Text(error.toString()),
                      ))),
            ]));
  }


    Widget titleWidget() {
    return const Text(
      'Notes',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
  Widget journalListView(List<Future<Journal>> data){
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return FutureBuilder<Journal>(
              future: data[index],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Material(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/notes_detail',
                                arguments: {'note': snapshot.data});
                          },
                          child: JournalEntry(journal: snapshot.data!)));
                } else {
                  return const SizedBox();
                }
              });
        }, childCount: data.length));
  }

  Widget journalGridView(data) {
    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8),
        delegate: SliverChildBuilderDelegate((context, index) {
          return FutureBuilder<Journal>(
              future: data[index],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Material(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/notes_detail',
                                arguments: {'note': snapshot.data});
                          },
                          child: JournalEntry(journal: snapshot.data!)));
                } else {
                  return const SizedBox();
                }
              });
        }, childCount: data.length));
  }
}

class JournalEntry extends StatelessWidget {
  Journal journal;

  JournalEntry({
    super.key,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    // creat a card with elevation 5 having a journal entry
    // with rows, columns and text widgets
    // with markdown support
    return Container(
      margin: const EdgeInsets.all(10),
      height: 150,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // create row header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // text with ellipsis
    
                  SizedBox(
                      width: 100,
                      child: Text(
                        journal.date,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Text(journal.timeAgo)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
    
              Text(
                journal.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  journal.content,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
