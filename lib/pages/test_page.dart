import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
                floating: true,
                pinned: true,
                snap: true,
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
                primary: true, // to turn off system padding
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text('Item #$index'),
                  ),
                  childCount: 1000,
                ),
              ),
            ]);
          },
        ),
      ),
    ));
  }
}

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
        begin: Alignment.center,
        end: Alignment.bottomLeft,
      ).evaluate(animation),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize:
                  Tween<double>(begin: 20.0, end: 14.0).evaluate(animation),
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
