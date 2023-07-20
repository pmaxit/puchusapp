import 'package:riverpod/riverpod.dart';

import '../commons.dart';
import 'song.dart';

List<Song> songs = [
  Song(
      songId: 0,
      title: 'A Sky Full of Stars',
      artist: 'Coldplay',
      album: 'Ghost Stories',
      albumArt:
          'https://mir-s3-cdn-cf.behance.net/project_modules/hd/137e8958616745.5a02fa9233814.jpg',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
];

List<Song> duplicateSongs =
    List.generate(10, (int index) => songs[0].copyWith(songId: index));

class SongApiClient {
  Future<List<Song>> getSongs() async {
    return duplicateSongs;
  }
}

// Provider for songs Api
// Path: lib/data/song_provider.dart
FutureProvider<List<Song>> songsProvider =
    FutureProvider<List<Song>>((ref) async {
  final apiClient = SongApiClient();
  return apiClient.getSongs();
});
