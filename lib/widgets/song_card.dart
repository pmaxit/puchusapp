import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/song.dart';
import '../data/states.dart';

class SongCard extends HookConsumerWidget {
  const SongCard({
    super.key,
    required this.song,
    required this.status,
  });

  final Song song;
  final bool status;

  void updateState(WidgetRef ref, ValueNotifier<bool> status) {
    // get the appstate
    final appState = ref.read(appStateProvider);
    // pause previous song
    //ref.read(appStateProvider.notifier).pauseSong(appState.songId, status);
    if (appState.songId != song.songId) {
      ref.read(appStateProvider.notifier).changeStatus(false);
    }
    // play current song
    if (status.value) {
      ref.read(appStateProvider.notifier).pauseSong(song.songId!, status);
    } else {
      ref.read(appStateProvider.notifier).playSong(song.songId!, status);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // use valueNotifier
    final vStatus = useValueNotifier(status);
    // get the appstate
    final appState = ref.read(appStateProvider);
    useAutomaticKeepAlive();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          // make the earlier state false

          vStatus.value = !vStatus.value;
          updateState(ref, vStatus);
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
          selected: appState.songId == song.songId,
        ),
      ),
    );
  }
}
