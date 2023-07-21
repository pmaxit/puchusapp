import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Header extends HookWidget {
  final double maxHeight;
  final double minHeight;

  const Header({Key? key, required this.maxHeight, required this.minHeight})
      : super(key: key);

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);

    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;

    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation, String title) {
    return Align(
      alignment: AlignmentTween(
        begin: Alignment.bottomCenter,
        end: Alignment.bottomLeft,
      ).evaluate(animation),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize:
                  Tween<double>(begin: 16.0, end: 24.0).evaluate(animation),
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = useValueNotifier("expansion Ratio: 0.0");

    return LayoutBuilder(
      builder: (context, constraints) {
        final expansionRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expansionRatio);
        message.value =
            "expansion Ratio: $expansionRatio\n toolbarHeight: ${kToolbarHeight} \n maxHeight: ${constraints.maxHeight} ";
        return Stack(fit: StackFit.expand, children: [
          ValueListenableBuilder(
              valueListenable: message,
              builder: (context, value, child) {
                return _buildTitle(animation, "Current Streak");
              })
        ]);
      },
    );
  }
}
