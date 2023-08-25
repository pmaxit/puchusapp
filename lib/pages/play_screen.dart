import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/pages/widgets/songs.dart';
import 'package:oneui/widgets/audio_widget.dart';

import 'widgets/play_widget.dart';

class PlayScreen extends HookConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double maxHeight = 220;
    double minHeight = 80;
    final ScrollController scrollController = useScrollController();
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
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
        
              bottom:  const TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5),
                automaticIndicatorColorAdjustment: true,
                labelColor: Colors.white,
                
                
                tabs: [
                  Tab(icon: Icon(Icons.mobile_friendly), text: 'Motivation',),
                  Tab(icon: Icon(Icons.album), text: 'Meditation'),
                  Tab(icon: Icon(Icons.airline_seat_legroom_normal), text: 'Affirmations'),
                ],
              )
              ),
             
               SliverFillRemaining(
                child: Column(children: [
                  const Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        SongsList(tab: "motivation"),
                        SongsList(tab: "motivation"),
                        
                        // third tab bar view widget
                        SongsList(tab: "motivation"),
                  
                      
                      ],),
                  ),
                  AudioWidget(),
                ],
                )
              )
              
   
            ]
        ),
      )
    );
  }

  Widget _body(BuildContext context, WidgetRef ref){

    return SliverList(
      delegate: SliverChildListDelegate([      
    // create tab bar view
    const Column(
      children: [
        TabBarView(
          children: [
          // first tab bar view widget
         SongsList(tab: "motivation"),
         SongsList(tab: "motivation"),
         
          // third tab bar view widget
          SongsList(tab: "motivation"),
    
        
        ],),
      ],
    ),

    // list of songs
    // play widget at the bottom
  

      ])
    );
    
  }

  Widget titleWidget(){
    return const Text(
      'Listen to Music',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}