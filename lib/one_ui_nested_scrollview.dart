import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OneUiNestedScrollView extends HookWidget {
  final List<Widget> tabs;
  final String title;
  double? expandedHeight;
  double? toolbarHeight;
  final BoxDecoration? boxDecoration;
  final Widget? collapsedWidget;
  final Icon? leadingIcon;

  OneUiNestedScrollView(
      {Key? key,
      required this.title,
      required this.tabs,
      this.expandedHeight,
      this.toolbarHeight,
      this.boxDecoration,
      this.collapsedWidget,
      this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).primaryColor,
                actions: const [
                  // Circle Avatar
                  Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/55942632?v=4"),
                    ),
                  ),
                ],
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("Puchu's App",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Divider(),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(80),
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Colors.grey,
                      indicatorPadding: const EdgeInsets.all(0.0),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(
                            icon: Icon(
                              Icons.grid_on,
                              size: 30.0,
                              semanticLabel: "Grid",
                            ),
                            text: "Grid"),
                        Tab(
                            icon: Icon(Icons.favorite_border_outlined,
                                size: 30.0),
                            text: "Favourite"),
                        Tab(
                            icon: Icon(Icons.bookmark_border, size: 30.0),
                            text: "Bookmark"),
                      ],
                    ),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: TabBarView(controller: tabController, children: tabs)),
        ),
      ),
    );
  }
}
