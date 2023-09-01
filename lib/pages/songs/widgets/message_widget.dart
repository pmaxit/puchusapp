import 'package:flutter/material.dart';

import '../../../utils/scroll_mixin.dart';

class MessageWidget extends StatefulWidget {
  String title;

  MessageWidget({Key? key, required this.title}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with ScrollHideOnClampedPoint {
  @override
  int get clampedPosition => 100;
  final widgetKey = GlobalKey();

  @override
  GlobalKey get keyWidget => widgetKey;

  @override
  Widget build(BuildContext context) {
    return Container(
        key: keyWidget,
        child: Opacity(
          opacity: opacity,
          child: Container(
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
