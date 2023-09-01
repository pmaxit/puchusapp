import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../bloc/app_state_provider.dart';

class PlayWidget extends HookConsumerWidget {
  final double size=40;
  final Color color=Colors.orangeAccent;
  const PlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider.notifier);
    final currentSong = appState.currentSong;

    bool isPlaying = appState.isPlaying;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      IconButton(
        icon:  Icon(Icons.skip_previous, color: color, size: size),
        onPressed: () {},
      ),
      IconButton(
        icon:  Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: color, size: size),
        onPressed: () {
          // get the current song
          if(currentSong != null) {
            appState.playSong(currentSong);
          }
        },
      ),
      IconButton(
        icon:  Icon(Icons.skip_next, color: color, size: size),
        onPressed: () {},
      ),
    ],);
  }
}