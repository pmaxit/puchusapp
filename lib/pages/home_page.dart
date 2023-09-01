import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/pages/widgets/fadeoutWidget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../bloc/app_state_provider.dart';
import 'widgets/card_button.dart';


class HomePage extends HookConsumerWidget {
  double maxHeight = 220;
  double minHeight = 80;
  double clampedHeight = 250;
  final ScrollController scrollController = ScrollController();

  HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController, slivers: [
      // SliverPersistentHeader(
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current -"),
      //   pinned: true,
      // ),
      SliverAppBar(
        pinned: true,
        floating: false,
        expandedHeight: maxHeight,
        flexibleSpace: _build_flexibleBar(context),
        automaticallyImplyLeading: false,
        primary: true,
        collapsedHeight: 100,
        title: const TitleWidget(),
        backgroundColor: Colors.deepOrange,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),

      // SliverPersistentHeader(
      //   pinned: true,
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
      // ),
      _body(context),


    ]));
  }

  Widget _build_flexibleBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FlexibleSpaceBar(
          background: _build_background(context),
          collapseMode: CollapseMode.pin,
        );
      },
    );
  }

  Widget _build_background(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            // StreakWidget(clampedPosition: 100),
            // StreakWidget(clampedPosition: 100),
            FadeOutWidget(
                child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Pmaxit, \nIt's Checkup Time",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            )),
            //MessageWidget(title: "3 days, 11 hour streak"),

            const SizedBox(height: 20),
            FadeOutWidget(
                child: Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.pushNamed(context, '/status');
                  },
                  child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Begin",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold)),
                      ))),
                ),
              ),
            ))
          ]),
        ));
  }

  Widget _body(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15.0),
      sliver: SliverList(
          delegate: SliverChildListDelegate([
        const SizedBox(
            height: 60,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Listen to",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
         CardButton(title: "Playlist", onTap: (){
                        Navigator.pushNamed(context, '/playScreen');

        },),
        const SizedBox(height: 12),
        const SizedBox(
            height: 60,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("After Checkup",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
        CardButton(title: "Notes", onTap: (){
                        Navigator.pushNamed(context, '/password');
        
        },),
        const SizedBox(height: 12),
        const SizedBox(
            height: 60,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Today",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
        Card(
          elevation: 3,
          borderOnForeground: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/todo');
            },
            borderRadius: BorderRadius.circular(30.0),
            child: const ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              leading: Icon(Icons.local_activity_rounded, size: 40),
              title: Text("Todo List"),
              trailing: Icon(Icons.arrow_forward_ios),
              isThreeLine: false,
            ),
          ),
        ),
        Card(
          elevation: 3,
          borderOnForeground: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: InkWell(
            onTap: () {
                    Navigator.pushNamed(context, '/journal');

            },
            borderRadius: BorderRadius.circular(30.0),
            child: const ListTile(
              leading: Icon(Icons.microwave_rounded, size: 40),
              title: Text("Motivation"),
              trailing: Icon(Icons.arrow_forward_ios),
              isThreeLine: false,
            ),
          ),
        ),
      ])),
    );
  }
}

class TitleWidget extends HookConsumerWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final currentState = ref.watch(currentStateProvider);

    return currentState.when(
      loading: (){
        return const Text("Loading");
      },
      error: (error, stackTrace){
        return const Text("Error");
      },
      data: (value){
        final rewiredPercentage = value['rewiredPercentage'];
        final currentGoal = value['currentGoal'];
        final victoryDays = value['victoryDays'];

        return SizedBox(
        width: double.infinity,
        child: Row(children: [
          CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 10.0,
              percent: rewiredPercentage/100,
              progressColor: Colors.green,
              center: Image.network(
                "https://cdn-icons-png.flaticon.com/512/1828/1828884.png",
                width: 10,
                height: 10,
              )),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("$rewiredPercentage% rewired",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text("$victoryDays victory days / $currentGoal days" ,
                  style:
                      TextStyle(color: Colors.deepOrange[200], fontSize: 16)),
            ],
          )
        ]));
      }
    );
  }
}
