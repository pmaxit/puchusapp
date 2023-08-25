import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/song.dart';
import '../bloc/app_state.dart';

class SongCard extends HookConsumerWidget {
  const SongCard({
    Key? key,
    required this.song,
    required this.status,
  }) : super(key: key);

  final Song song;
  final bool status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // use valueNotifier
    print('${song.songId} :::: ${status}');
    final vStatus = useValueNotifier(status);

    // subscribe to the changes
    final appState = ref.read(appStateProvider.notifier);

    useAutomaticKeepAlive();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          vStatus.value = !vStatus.value;
          print('on Tap');
          //updateAppState();
          //appState.copyWith(isPlaying: vStatus.value, currentSong: song);
        },
        child: ListTile(
            leading: Image.network(song.albumArt!),
            title: Text(song.title!),
            subtitle: Text(song.artist!),
            trailing: ValueListenableBuilder(
              valueListenable: vStatus,
              key: ValueKey(song.title),
              builder: (context, bool status, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status)
                    const Icon(Icons.pause, color: Colors.black, size: 30)
                  else
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 30,
                    ),
                ],
              ),
            ),
            isThreeLine: false,
            selected: vStatus.value),
      ),
    );
  }
}
