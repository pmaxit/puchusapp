import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:oneui/one_ui_nested_scrollview.dart';

import 'commons.dart';
import 'data/api.dart';
import 'data/song.dart';
import 'data/states.dart';
import 'widgets/audio_widget.dart';
import 'widgets/song_card.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
          sliderTheme: const SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
          )),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // songs Provider
    final songs = ref.watch(songsProvider);

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
                  children: [_buildSongList(songs, ref)],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildSongList(songs, ref)],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildSongList(songs, ref)],
                ),
              ],
            )),
        bottomNavigationBar: const AudioWidget());
  }

  Widget _buildSongList(AsyncValue<List<Song>> songs, WidgetRef ref) {
    // current song

    return Expanded(
      child: songs.when(
        data: (songs) {
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final currentSong = ref.watch(appStateProvider).currentSong;
              final isPlaying = ref.watch(appStateProvider).isPlaying;
              final song = songs[index];

              return ListTile(
                onTap: () {
                  // update the app state
                  ref.read(appStateProvider.notifier).toggleSong(song);
                },
                leading: Image.network(song.albumArt!),
                title: Text(song.title!),
                subtitle: Text(song.artist!),
                trailing: Icon(
                  Icons.play_circle_fill_rounded,
                  size: 30,
                  color: (currentSong?.songId == song.songId && isPlaying)
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
      ),
    );
  }
}
