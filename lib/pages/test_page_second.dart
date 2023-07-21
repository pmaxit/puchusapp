import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oneui/pages/widgets/streak_widget.dart';

import 'widgets/flexible_bar.dart';
import 'widgets/goal_widget.dart';

class TestPageSecond extends HookWidget {
  final double maxHeight = 200;
  final double minheight = 80;
  const TestPageSecond({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showButtomBar = useState(false);
    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        if (controller.position.pixels > (maxHeight - minheight)) {
          showButtomBar.value = true;
        } else {
          showButtomBar.value = false;
        }
      });
      return;
    }, [controller]);

    return Scaffold(
        body: CustomScrollView(controller: controller, slivers: [
      SliverAppBar(
        pinned: true,
        expandedHeight: 200,
        primary: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedHeight: kToolbarHeight,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Header(
          maxHeight: 200 + kToolbarHeight,
          minHeight: 80,
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Visibility(
            visible: showButtomBar.value,
            child: Container(
              color: Colors.grey.shade300,
              height: 1,
            ),
          ),
        ),
      ),
      body(),
      infiniteList(),
    ]));
  }

  Widget body() {
    return SliverList(
        delegate: SliverChildListDelegate([
      const SizedBox(height: 20),
      StreakWidget(),
    ]));
  }

  Widget infiniteList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        return GoalWidget();
      },
      childCount: 100,
    ));
  }
}
