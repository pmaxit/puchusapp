import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/api.dart';
import '../../data/song.dart';

class SongsList extends HookConsumerWidget {
  final String tab;

  const SongsList({super.key, required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsByTabProvider("motivation"));

    return songs.when(data: 
    (songs) => _buildList(songs),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => Text('Error: $err'),
    );        
  }

  Widget _buildList(List<Song> songs){
    return ListView.builder(
      itemCount: songs.length,
      itemExtent: 80,
      itemBuilder: (context, index) {
        return ListTile(
          
          title: Text(songs[index].title!),
          subtitle: Text(songs[index].artist!),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(songs[index].albumArt!),
          ),
          onTap: () {
            //Navigator.pushNamed(context, '/play', arguments: songs[index]);
          },
          trailing: const Icon(Icons.play_arrow),
        );
      },
    );

  }
}