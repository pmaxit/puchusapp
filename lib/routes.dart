
import 'pages/check_status.dart';
import 'pages/home_page.dart';
import 'pages/play_screen.dart';
import 'pages/test_page.dart';
import 'pages/test_page_second.dart';
import 'pages/home_page.dart';

final routes = {
        '/': (context) =>  HomePage(),
        '/test': (context) => const TestPage(),
        '/second': (context) => const TestPageSecond(),
        '/playScreen': (context) =>  PlayScreen(),
        '/status': (context) => const StatusCheck(),
      };