import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageTemplate extends HookConsumerWidget {
  const PageTemplate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double maxHeight = 220;
    double minHeight = 80;
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: true,
              primary: true,
              collapsedHeight: minHeight,
              title:  titleWidget(),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.deepOrange,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
          ]
      )
    );
  }

  Widget titleWidget(){
    return const Text(
      'One UI',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}