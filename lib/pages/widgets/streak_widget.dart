import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../utils/scroll_mixin.dart';

class StreakWidget extends StatefulWidget {
  final int clampedPosition;

  const StreakWidget({Key? key, this.clampedPosition = 100}) : super(key: key);

  @override
  StreakWidget2State createState() => StreakWidget2State();
}

class StreakWidget2State extends State<StreakWidget>
    with ScrollHideOnClampedPoint {
  final widgetKey = GlobalKey();

  @override
  int get clampedPosition => widget.clampedPosition;

  @override
  GlobalKey get keyWidget => widgetKey;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        key: keyWidget,
        margin: const EdgeInsets.all(12),
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange,
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1 day streak, keep it up!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                'Your best streak is 103 days !',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
