import 'package:flutter/material.dart';

import '../../utils/scroll_mixin.dart';

class FadeOutWidget extends StatefulWidget {
  final Widget child;
  final int clampedPosition;
  final GlobalKey keyWidget = GlobalKey();

  FadeOutWidget({super.key, required this.child, this.clampedPosition = 100});

  @override
  _FadeOutWidgetState createState() => _FadeOutWidgetState();
}

class _FadeOutWidgetState extends State<FadeOutWidget>
    with ScrollHideOnClampedPoint {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      key: keyWidget,
      opacity: opacity,
      child: widget.child,
    );
  }

  @override
  // TODO: implement clampedPosition
  int get clampedPosition => 100;

  @override
  // TODO: implement keyWidget
  GlobalKey<State<StatefulWidget>> get keyWidget => widget.keyWidget;
}
