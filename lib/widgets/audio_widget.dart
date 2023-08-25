import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/app_state.dart';

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class AudioWidget extends HookConsumerWidget {
  @override
  final Key? key;
  StreamSubscription<Duration>? subscription;

  AudioWidget({
    this.key,
  }) : super(key: key);

  void pauseSubscription() {
    subscription?.pause();
  }

  void resumeSubscription() {
    subscription?.resume();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(appStateProvider.notifier).currentSong;
    final isPlaying = ref.watch(appStateProvider.notifier).isPlaying;
    
    
    final sliderValue = useState(0.0);
    final durationValue = useState<double>(0.0);

    print("new song : ${song?.title} isPlaying : $isPlaying ");
    final audioPlayer = useMemoized(() {
      final player = AudioPlayer();

      player.setLoopMode(LoopMode.one);

      if (song?.url != null) {
        player.setUrl(song!.url);
      }

      return player;
    }, [song]);

    // create audio player
    useEffect(() {
      // async function

      if (isPlaying) {
        audioPlayer.play();
      } else {
        audioPlayer.pause();
      }
      return () => audioPlayer.dispose();
    }, [audioPlayer, song]);

    // listen to audio Player changes
    useEffect(() {
      subscription = audioPlayer.positionStream.listen((position) {
        sliderValue.value = position.inSeconds.toDouble();
      });

      final durationSubscription =
          audioPlayer.durationStream.listen((duration) {
        durationValue.value = duration!.inSeconds.toDouble();
      });

      // listen to audio player state changes
      final playerStateSubscription =
          audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.pause();
        }
      });

      return () {
        subscription?.cancel();
        durationSubscription.cancel();
        playerStateSubscription.cancel();
      };
    }, [audioPlayer, song]);

    // play pause audio
    useEffect(() {
      if (isPlaying) {
        audioPlayer.play();
      } else {
        audioPlayer.pause();
      }
      return null;
    }, [isPlaying]);

    return Container(
        height: 150,
        color: Colors.deepOrangeAccent,
        child: Column(
          children: [
            // song progress bar
            Row(
              children: [
                const SizedBox(width: 24),
                Text(
                    formatDuration(
                        Duration(seconds: sliderValue.value.toInt())),
                    style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: durationValue.value,
                    value: sliderValue.value,
                    onChanged: (value) {
                      pauseSubscription();
                      // cancel stream
                      final newValue = double.parse(value.toStringAsFixed(4));
                      sliderValue.value = newValue;
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    onChangeEnd: (value) {
                      // if (subscription != null) {
                      //   subscription!.resume();
                      // }
                      resumeSubscription();
                      audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Text(
                    formatDuration(
                        Duration(seconds: durationValue.value.toInt())),
                    style: TextStyle(color: Colors.white)),
                const SizedBox(width: 24),
              ],
            ),
            Row(
              children: [
                // song image
         
                // song label
                Expanded(
                    child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 40),
                        onPressed: () {},
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(
                            isPlaying
                                ? Icons.pause
                                : Icons.play_circle_fill_rounded,
                            size: 60),
                        onPressed: () {
                          // toggle the last playing song
                          ref.read(appStateProvider.notifier).toggleSong(song);
                        },
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 40),
                        onPressed: () {},
                        color: Colors.white,
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ))

                // reshuffle Icon,
              ],
            )
          ],
        ));
  }
}
