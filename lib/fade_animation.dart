import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final bool isExpanded;

  const FadeAnimation({
    Key? key,
    required this.animation,
    required this.child,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity:
            Tween<double>(begin: isExpanded ? 1 : 0, end: isExpanded ? 0 : 1)
                .animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1),
          ),
        ),
        child: child);
  }
}
