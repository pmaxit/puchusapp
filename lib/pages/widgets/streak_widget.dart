import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StreakWidget extends HookWidget {
  final keyWidget = GlobalKey();
  final int clampedPosition;
  int initialY = -1;

  // access the scroll position
  StreakWidget({Key? key, this.clampedPosition = 95}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opacity = useState<double>(0);
    final scrollController = Scrollable.of(context).widget.controller;

    useEffect(() {
      scrollController?.addListener(() {
        final RenderBox? renderBox =
            keyWidget.currentContext?.findRenderObject() as RenderBox?;
        final position = renderBox?.localToGlobal(Offset.zero);
        print("dx: ${position?.dy}");

        if (initialY == -1) {
          print('setting initialY again ');
          initialY = position?.dy.toInt() ?? 0;
        }
        int newPosition = position?.dy.toInt() ?? 0;

        double newOpacity = clampDouble(
            (newPosition - clampedPosition) / (initialY - clampedPosition),
            0,
            1);

        opacity.value = newOpacity;
        print('opacity : $newOpacity $newPosition $initialY');
      });
    }, [scrollController]);

    return Opacity(
      opacity: opacity.value,
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
