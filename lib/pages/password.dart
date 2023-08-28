import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/app_state.dart';

import '../bloc/password_state.dart';

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scrollController = useScrollController();
    final appState = ref.watch(appStateProvider.notifier);
    final passwordState = ref.watch(passwordProvider);


    passwordState.addListener(() {
      if(passwordState.passwordStateEnum == PasswordStateEnum.correct){
        // go to next page
        // reset password
        passwordState.passwordList.clear();
        // got to notes list
        Navigator.pushNamed(context, '/notes');
      }else if(passwordState.passwordStateEnum == PasswordStateEnum.incorrect){
        // reset password
        passwordState.passwordList.clear();
        // pop up
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect Password")));
        //Navigator.pop(context);
      }});


     return Scaffold(
        // floating action button
        
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
            title: const Text("Password"),
            floating: true,
            actions: [
              IconButton(onPressed: (){ 
              
              }, icon: const Icon(Icons.search, color: Colors.white))
            ]
          ),
          
          // SliverToBoxAdapter(child: buildPasswordPage(
          // ))

          SliverGrid.builder(gridDelegate: 
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, 
          crossAxisSpacing: 30, mainAxisSpacing: 90
          ),
           itemBuilder: (context, index){
            return Material(child: InkWell(
              onTap: (){
                passwordState.addToPassword(index);
              },
              child: PasswordEntry(index: index)));
          }, itemCount: 12
          
          )]));
  }
}

class PasswordEntry extends StatelessWidget {
  final int index;
  
  
   PasswordEntry({super.key, required this.index});

    // Random list of colors 
    List<Color> colors = [
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.green,
      Colors.blue,
      Colors.pink,
      Colors.red,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.indigo,
      Colors.teal,
      Colors.cyan,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.lime,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.amber,
      Colors.black,
      Colors.white
    ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors[index]
        ),
        height: 10, width: 10));
  }
}
