// mixin is just a class without constructor
import 'dart:ui';

import 'package:flutter/material.dart';

mixin ScrollHideOnClampedPoint<T extends StatefulWidget> on State<T> {
  late ScrollController? scrollController;
  int initialY = -1;
  double opacity = 1;
  int position = 0;

  int get clampedPosition;
  GlobalKey get keyWidget;

  void _scrollListener() {
    setState(() {
      getPosition();
    });
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Here you can have your context and do what ever you want
      // get position
      RenderBox? renderBox =
          keyWidget.currentContext?.findRenderObject() as RenderBox?;
      var newposition = renderBox?.localToGlobal(Offset.zero);

      if (initialY == -1) {
        initialY = newposition!.dy.toInt();
      }
      if (newposition!.dy.toInt() < clampedPosition) {
        position = newposition.dy.toInt();
        opacity = clampDouble(
            (position - clampedPosition) / (initialY - clampedPosition), 0, 1);
      } else {
        position = newposition.dy.toInt();
        opacity = clampDouble(
            (position - clampedPosition) / (initialY - clampedPosition), 0, 1);
      }
    });
  }

  @override
  void didChangeDependencies() {
    scrollController = Scrollable.of(context).widget.controller;
    scrollController?.addListener(() {
      _scrollListener();
    });
    super.didChangeDependencies();
  }
}
