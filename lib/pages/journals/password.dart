import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/custom_login_provider.dart';


class PasswordPage extends HookConsumerWidget {
  const PasswordPage({super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scrollController = useScrollController();
    final customLogin = ref.watch(customLoginProvider);
    final currentPassword = useState<String>("");


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
          
          // SliverToBoxAdapter(child: buildPasswordPage(
          // ))

          SliverGrid.builder(gridDelegate: 
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, 
          crossAxisSpacing: 20, mainAxisSpacing: 10
          ),
           itemBuilder: (context, index){
            return Material(
              color: Colors.transparent,
              child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: InkWell(
                onTap: (){
                  currentPassword.value = currentPassword.value + index.toString();
                  if(currentPassword.value.length == 4){
                    customLogin.checkPassword(currentPassword.value);
                    Navigator.pushReplacementNamed(context, '/notes');
                    currentPassword.value = "";
                  }
                },
                child: PasswordEntry(index: index)),
            ));
          }, itemCount: 12
          
          ),
          const SliverToBoxAdapter(child: const SizedBox(height: 100,width: double.infinity)),
          
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
          borderRadius: index %2 == 0 ? BorderRadius.circular(10): BorderRadius.zero,
          color: colors[index]
        ),
        height: 10, width: 10));
  }
}
