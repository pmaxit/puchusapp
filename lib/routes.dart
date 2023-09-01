
import 'login/landing.dart';
import 'login/login.dart';
import 'login/signup.dart';
import 'login/splash.dart';
import 'pages/journals/create_note.dart';
import 'pages/journals/notes_detail.dart';
import 'pages/journals/notes_page.dart';
import 'pages/status/check_status.dart';
import 'pages/home_page.dart';
import 'pages/motivations/posts_screen.dart';
import 'pages/journals/password.dart';
import 'pages/songs/play_screen.dart';
import 'pages/todo/todo_page.dart';

final routes = {
        '/': (context) =>  HomePage(),
        '/playScreen': (context) =>  const PlayScreen(),
        '/status': (context) => const StatusCheck(),
        '/journal': (context) => const PostsScreen(),
        '/notes': (context) => const NotesPage(),
        '/notes_detail': (context) => const NotesDetail(),
        '/create_notes': (context) => const CreateNote(),
        '/password': (context) => const PasswordPage(),
        '/signup': (context) =>  SignUpPage(),
        '/login': (context) =>  LoginPage(),
        '/landing': (context) =>  const LandingPage(),
        '/splash': (context) =>  const ImageSplashScreen(),
        '/todo': (context) =>  const TodoPage(),
      };