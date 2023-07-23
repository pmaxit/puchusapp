import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneui/pages/widgets/goal_widget.dart';
import 'package:oneui/pages/widgets/streak_widget.dart';

import 'widgets/flexible_custom_bar.dart';

class TestPageThird extends StatelessWidget {
  double maxHeight = 120;
  double minHeight = 80;
  double clampedHeight = 250;

  TestPageThird({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: minHeight,
        pinned: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: CustomHeaderDelegate(Colors.deepOrange, "Current Streak"),
      ),

      SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Card(
                    child: ListTile(
                  leading: Icon(Icons.ac_unit),
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
        //print(constraints.maxHeight);
        final expandRatio = clampDouble(
            (constraints.maxHeight - clampedHeight) /
                (maxHeight - clampedHeight),
            0,
            1);

        final animation = CurvedAnimation(
            parent: AlwaysStoppedAnimation(expandRatio),
            curve: Curves.fastOutSlowIn);
        return FlexibleSpaceBar(
          background: _build_background(context, animation),
          collapseMode: CollapseMode.pin,
        );
      },
    );
  }

  Widget _build_background(BuildContext context, Animation animation) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [StreakWidget()]));
  }

  Widget _body() {
    return SliverFillRemaining(child: Container());
  }
}
