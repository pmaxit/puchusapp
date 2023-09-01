import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/app_state_provider.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/post_model.dart';
import 'package:uuid/uuid.dart';


class CreateNote extends HookConsumerWidget {
  const CreateNote({super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scrollController = useScrollController();
    final titleEditor = useTextEditingController();
    final contentEditor = useTextEditingController();

    final onSubmit = useCallback(() async {
      final title = titleEditor.text;
      final content = contentEditor.text;
      final note = Journal(
        user: ref.read(currentUserProvider),
        documentId: const Uuid().v4(),
        title: title, content: content, date: DateTime.now().toString(), timeAgo: 'Now');
      await ref.read(firebaseDBProvider).addJournal(note);
      
      if(context.mounted) Navigator.pop(context);
    },[]);

     return Scaffold(
        // floating action button
        
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController, slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: const Text("Create Note"),
            floating: true,
            actions: [
              IconButton(onPressed: (){ 
              
              }, icon: const Icon(Icons.search, color: Colors.white))
            ]
          ),
          
          SliverToBoxAdapter(child: buildNotesDetail(
            titleEditor: titleEditor,
            contentEditor: contentEditor
          )),
          
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(child: submitButton(onSubmit: onSubmit)))
    ]));
  }

  Widget buildNotesDetail({required TextEditingController titleEditor, required TextEditingController contentEditor}){
    
    // create note widget
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TextField(
          controller: titleEditor,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Title',
          ),
        ),
        const SizedBox(height: 10,),
         TextField(
          controller: contentEditor,
          minLines: 18,
          maxLines: 35,
          decoration: const InputDecoration(
          
            border: OutlineInputBorder(),
            labelText: 'What do you want to write about?',
          ),
        ),
      ],),
    );
  }

  Widget submitButton({required Function onSubmit}){
    return Container( alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: (){

      onSubmit();
    }, child: const Text("Submit")));
  }
  
}
