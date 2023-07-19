import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/one_ui_nested_scrollview.dart';

import 'commons.dart';
import 'data/api.dart';
import 'data/song.dart';
import 'data/states.dart';
import 'widgets/song_card.dart';

void main() {
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
      title: 'One UI App Bar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // songs Provider
    final songs = ref.watch(songStatusProvider);
    final isRunning = useState(false);

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.light),
            child: OneUiNestedScrollView(
              title: "Puchu's Music App",
              collapsedWidget: const Text("Puchu's Music App",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              leadingIcon: const Icon(Icons.menu, color: Colors.white),
              boxDecoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              )),
              // futureprovider
              tabs: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildSongList(songs, isRunning)],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildSongList(songs, isRunning)],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ],
            )),
        bottomNavigationBar: _buildMediaButtons(context, isRunning, ref));
  }

  Widget _buildSongList(AsyncValue<List<Tuple<Song, bool>>> songs,
      ValueNotifier<bool> isRunning) {
    return Expanded(
      child: songs.when(
        data: (songs) {
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index].x;
              final status = songs[index].y;
              return SongCard(song: song, status: status);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
      ),
    );
  }

  Widget _buildMediaButtons(
      BuildContext context, ValueNotifier<bool> isRunning, WidgetRef ref) {
    // app state
    final appState = ref.watch(appStateProvider);

    return BottomAppBar(
      height: 100,
      elevation: 5,
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 40),
                onPressed: () {},
                color: Colors.white,
              ),
              ValueListenableBuilder(
                  valueListenable: appState.status,
                  builder: (context, value, child) {
                    return IconButton(
                      icon: Icon(
                          value ? Icons.pause : Icons.play_circle_fill_rounded,
                          size: 60),
                      onPressed: () {
                        appState.status.value = !appState.status.value;
                        isRunning.value = !isRunning.value;
                      },
                      color: Colors.white,
                    );
                  }),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 40),
                onPressed: () {},
                color: Colors.white,
              ),
              Spacer(flex: 1),
              // reshuffle Icon,
            ],
          ),

          // reshuffle icon
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.shuffle, size: 30),
              onPressed: () {},
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
