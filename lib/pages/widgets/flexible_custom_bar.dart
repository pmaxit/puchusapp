import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oneui/pages/widgets/streak_widget.dart';

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  final double maxHeight = 200;
  final double minHeight = 100;

  CustomHeaderDelegate(this.backgroundColor, this._title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    final progress = clampDouble((maxExtent - minExtent), 0, 1);

    return Stack(fit: StackFit.expand, children: [
      ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(1),
              Colors.deepOrange.withOpacity(0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          )),
        ),
      )
    ]);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
