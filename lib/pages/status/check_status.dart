import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../bloc/app_state_provider.dart';
import '../../bloc/auth_provider.dart';

class StatusCheck extends HookConsumerWidget {
  const StatusCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double maxHeight = 220;
    double minHeight = 80;
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: true,
              primary: true,
              collapsedHeight: minHeight,
              title:  titleWidget(),
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
            _body(context, ref),
          ]
      )
    );
  }

  Widget _body(BuildContext context, WidgetRef ref){

    // get app state
    final appState = ref.watch(appStateProvider.notifier);
    final textEditingController = useTextEditingController();
    final firebaseDB = ref.read(firebaseDBProvider);
    // add textbox
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Status Check',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
                            const SizedBox(height: 20),
              TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Enter your current streak',
                ),
                
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // update app state
                  appState.updateVictoryDays(textEditingController.text);

                  // update firebase
                  firebaseDB.updateUser(appState.toJson());
                  Navigator.pop(context);

                },
                child:  const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('Submit', style: TextStyle(fontSize: 20))),
              ),
            ],
          ),
        ),
      
      ])
    );
  }

  Widget titleWidget(){
    return const Text(
      'One UI',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}