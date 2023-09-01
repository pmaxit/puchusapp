import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/post_model.dart';

import '../../config/markdownconfig.dart';


class NotesDetail extends HookConsumerWidget {
  const NotesDetail({super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scrollController = useScrollController();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final note = args['note'] as Journal;
    final textController = useTextEditingController(text: note.content);

     return Scaffold(
        // floating action button
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Add your onPressed code here!
            Journal updatedNote = Journal(
              documentId: note.documentId,
              user: note.user,
              title: note.title,
              content: textController.text,
              date: note.date,
              timeAgo: note.timeAgo,

             
            );
            ref.read(firebaseDBProvider).addJournal(updatedNote);
          },
          backgroundColor: Colors.deepOrange,
          child: const Icon(Icons.save, color: Colors.white,),
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController, slivers: [
      // SliverPersistentHeader(
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
      //   pinned: true,
      // ),
 SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: true,
            primary: true,
            collapsedHeight: 80,
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

          SliverToBoxAdapter(child: buildNotesDetail(note, textController))
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

  Widget buildNotesDetail(Journal note, TextEditingController textController){
    return FutureBuilder(
      future: rootBundle.loadString("assets/notes/08272023.md"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              style: const TextStyle(fontSize: 18),
              minLines: 20,
              maxLines: 20,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Start writing here...",
                hintStyle: TextStyle(fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
                ),
              ),
              
              ),
          );
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
  
}
