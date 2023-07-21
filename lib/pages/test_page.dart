import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oneui/pages/widgets/streak_widget.dart';

import 'widgets/flexible_bar.dart';
import 'widgets/goal_widget.dart';

class TestPage extends HookWidget {
  final double maxHeight = 120;
  final double minheight = 60;
  const TestPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showButtomBar = useState(false);
    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        if (controller.position.pixels >= minheight - 1) {
          showButtomBar.value = true;
        } else {
          showButtomBar.value = false;
        }
      });
      return;
    }, [controller]);

    return Scaffold(
        body: SafeArea(
      child: NestedScrollView(
        floatHeaderSlivers: true,
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                toolbarHeight: minheight,
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
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                primary: false, // to turn off system padding
                collapsedHeight: minheight,
                expandedHeight: maxHeight,
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: Header(
                  maxHeight: maxHeight,
                  minHeight: minheight,
                ),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: StreakWidget(),
              )),
              SliverPadding(
                  padding: EdgeInsets.only(top: 32),
                  sliver: SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: GoalWidget(),
                  ))),
              SliverFillRemaining(
                  child: Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: Text('Body'),
                ),
              ))
            ]);
          },
        ),
      ),
    ));
  }
}
