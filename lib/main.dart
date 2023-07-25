import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/pages/home_page.dart';
import 'package:oneui/pages/test_page.dart';
import 'package:oneui/pages/test_page_three.dart';

import 'pages/test_page_second.dart';

Future<void> main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'One UI App Bar',
      theme: ThemeData(
          applyElevationOverlayColor: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          sliderTheme: const SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
          )),
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/test': (context) => const TestPage(),
        '/second': (context) => const TestPageSecond(),
        '/third': (context) => TestPageThird(),
      },
      initialRoute: '/',
    );
  }
}
