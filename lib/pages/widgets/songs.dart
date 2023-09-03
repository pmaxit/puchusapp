import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';

import '../../bloc/app_state_provider.dart';
import '../../models/api.dart';
import '../../models/song.dart';

class SongsList extends HookConsumerWidget {
  final String tab;

  const SongsList({super.key, required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsByTabProvider(tab));
    final currentSong = ref.watch(appStateProvider).currentSong;

    return songs.when(
      data: (songs) => _buildList(songs, currentSong),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }

  Widget _buildList(List<Song> songs, Song? currentSong) {
    return ListView.builder(
      itemCount: songs.length,
      itemExtent: 80,
      itemBuilder: (context, index) {
        return Consumer(builder: (context, ref, child) {
          final appState = ref.watch(appStateProvider.notifier);
          final song = songs[index];
          return ListTile(
            selected: currentSong == song,
            title: Text(song.title!),
            subtitle: Text(song.artist!),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.albumArt!),
            ),
            onTap: () {
              appState.setNewSong(song);
              //Navigator.pushNamed(context, '/play', arguments: songs[index]);
            },
            trailing: const Icon(Icons.play_arrow),
          );
        });
      },
    );
  }
}
