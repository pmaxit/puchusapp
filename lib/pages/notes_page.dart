import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/app_state.dart';
import 'package:oneui/models/post_model.dart';

class NotesPage extends HookConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scrollController = useScrollController();
    final journals = ref.watch(appStateProvider).journals;

     return Scaffold(
        // floating action button
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, '/create_notes');
          },
          child: const Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.deepOrange,
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController, slivers: [
      // SliverPersistentHeader(
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
      //   pinned: true,
      // ),
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: const Text('Journal'),
            floating: true,
            actions: [
              IconButton(onPressed: (){ 
              
              }, icon: const Icon(Icons.search, color: Colors.white))
            ]
          ),

          SliverGrid.builder(gridDelegate: 
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
          , itemBuilder: (context, index){
            return Material(child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/notes_detail', arguments: {'note': journals[index]});
              },
              child: JournalEntry(journal: journals[index])));
          }, itemCount: journals.length)

    ]));
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
    return Card(
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
                  child: Text(journal.date, overflow: TextOverflow.ellipsis, )),
                Text(journal.timeAgo)
              ],
            ),
            const SizedBox(height: 10,),
            
            Text(journal.title, style: const TextStyle(fontWeight: FontWeight.bold),),
            Text(journal.content, style: const TextStyle(fontWeight: FontWeight.normal),)
          ],
        ),
      ),
    );

  }
}