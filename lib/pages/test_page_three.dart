import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:oneui/pages/widgets/fadeoutWidget.dart';
import 'package:oneui/pages/widgets/goal_widget.dart';
import 'package:oneui/pages/widgets/streak_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../widgets/message_widget.dart';
import 'widgets/flexible_custom_bar.dart';

class TestPageThird extends StatelessWidget {
  double maxHeight = 300;
  double minHeight = 80;
  double clampedHeight = 250;
  final ScrollController scrollController = ScrollController();

  TestPageThird({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(controller: scrollController, slivers: [
      // SliverPersistentHeader(
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
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
        title: _buildTitle(),
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),

      SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Card(
                    child: ListTile(
                  leading: Icon(Icons.ac_unit, color: Colors.deepOrange),
                  title: Text("AC UNIT is ON !"),
                )));
          }, childCount: 10),
          itemExtent: 150),
      // SliverPersistentHeader(
      //   pinned: true,
      //   delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
      // ),
      _body()
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

  Widget _buildTitle() {
    return Container(
        width: double.infinity,
        child: Row(children: [
          CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 10.0,
              percent: 1,
              progressColor: Colors.green,
              center: Image.network(
                "https://cdn-icons-png.flaticon.com/512/1828/1828884.png",
                width: 10,
                height: 10,
              )),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Streak",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text("100 days",
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          )
        ]));
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
            MessageWidget(title: "3 days, 11 hour streak"),
            FadeOutWidget(
              child: Row(
                children: [
                  Container(
                      height: 50,
                      color: Colors.white.withOpacity(0.3),
                      child: Text("hello world")),
                  const SizedBox(width: 10),
                  Container(
                      height: 50,
                      color: Colors.white.withOpacity(0.3),
                      child: Text("hello world"))
                ],
              ),
            ),
            const SizedBox(height: 10),
            MessageWidget(
                title:
                    "You are on 100 days streak \n Congratulations. Keep it up"),
          ]),
        ));
  }

  Widget _body() {
    return SliverFillRemaining(child: Container());
  }
}
