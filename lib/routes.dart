
import 'pages/check_status.dart';
import 'pages/create_note.dart';
import 'pages/home_page.dart';
import 'pages/journal_screen.dart';
import 'pages/notes_detail.dart';
import 'pages/notes_page.dart';
import 'pages/password.dart';
import 'pages/play_screen.dart';
import 'pages/test_page.dart';
import 'pages/test_page_second.dart';

final routes = {
        '/': (context) =>  HomePage(),
        '/test': (context) => const TestPage(),
        '/second': (context) => const TestPageSecond(),
        '/playScreen': (context) =>  const PlayScreen(),
        '/status': (context) => const StatusCheck(),
        '/journal': (context) => const JournalScreen(),
        '/notes': (context) => const NotesPage(),
        '/notes_detail': (context) => const NotesDetail(),
        '/create_notes': (context) => const CreateNote(),
        '/password': (context) => const PasswordPage(),
      };