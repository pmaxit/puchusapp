import 'package:riverpod/riverpod.dart';

import '../commons.dart';
import 'song.dart';

List<String> tabs = [
  'Puchus',
  'Papa',
  'Mummy',
];

List<Song> songs = [
  Song(
      tab: 'Puchus',
      songId: 0,
      title: 'A Sky Full of Stars',
      artist: 'Coldplay',
      album: 'Ghost Stories',
      albumArt:
          'https://mir-s3-cdn-cf.behance.net/project_modules/hd/137e8958616745.5a02fa9233814.jpg',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  Song(
      tab: 'Papa',
      songId: 1,
      title: 'A Sky Full of Stars',
      artist: 'Papa',
      album: 'Ghost Stories',
      albumArt:
          'https://mir-s3-cdn-cf.behance.net/project_modules/hd/137e8958616745.5a02fa9233814.jpg',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  Song(
      tab: 'Mummy',
      songId: 2,
      title: 'Mummy: A Sky Full of Stars',
      artist: 'Mummy',
      album: 'Ghost Stories',
      albumArt:
          'https://mir-s3-cdn-cf.behance.net/project_modules/hd/137e8958616745.5a02fa9233814.jpg',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
];

List<Song> getSongsByTab(String tab) {
  return songs.where((element) => element.tab == tab).toList();
}

class SongApiClient {
  Future<List<Song>> getSongsByTab(String tab) async {
    return Future.value(songs.where((element) => element.tab == tab).toList());
  }

  Future<List<Song>> getSongs() async {
    return Future.value(songs);
  }

  // get all tabs
  List<String> getTabs() {
    return tabs;
  }
}

// apiprovider
final songApiClientProvider = Provider<SongApiClient>((ref) {
  return SongApiClient();
});

// Provider for songs by tab
// Path: lib/data/song_provider.dart
final songsByTabProvider =
    FutureProvider.family<List<Song>, String>((ref, tab) async {
  final apiClient = SongApiClient();
  return apiClient.getSongsByTab(tab);
});

// Provider for songs Api
// Path: lib/data/song_provider.dart
FutureProvider<List<Song>> songsProvider =
    FutureProvider<List<Song>>((ref) async {
  final apiClient = SongApiClient();
  return apiClient.getSongs();
});
