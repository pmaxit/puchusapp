import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                          "https://www.freepnglogos.com/uploads/boss-baby-png/boss-baby-poses-kaylor-deviantart-0.vDlm268Zp_H4JCKqdoohBs7pEOPtgsNCuJqGdaTKhKM"),
                    ),
                  ),
                ],
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Center(
                        child: Text("Puchu's App",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ),
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
                            icon: FaIcon(
                              FontAwesomeIcons.child,
                              size: 30.0,
                            ),
                            text: "Puchu"),
                        Tab(
                            icon: FaIcon(
                              FontAwesomeIcons.personBiking,
                              size: 30.0,
                            ),
                            text: "Papa"),
                        Tab(
                            icon: FaIcon(
                              FontAwesomeIcons.personPregnant,
                              size: 30.0,
                            ),
                            text: "Mumma"),
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
