import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'song.dart';

List<String> tabs = [
  'motivation',
  'Papa',
  'Mummy',
];

List<Song> songs = [
  Song(
      tab: 'motivation',
      songId: 0,
      title: 'A Sky Full of Stars',
      artist: 'Coldplay',
      album: 'Ghost Stories',
      albumArt:
          'https://www.pngall.com/wp-content/uploads/2016/04/Happy-Person-Free-Download-PNG.png',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  Song(
      tab: 'Papa',
      songId: 1,
      title: 'A Sky Full of Stars',
      artist: 'Papa',
      album: 'Ghost Stories',
      albumArt:
          'https://www.pngall.com/wp-content/uploads/2016/04/Happy-Person-Free-Download-PNG.png',
      url:
          "https://storage.googleapis.com/sogslullabies/Mouj%20Lajyoo%20Adde%20Kaleo%20-%20Kashmiri%20Lori%20(1).mp3"),
  Song(
      tab: 'Mummy',
      songId: 2,
      title: 'Mummy: A Sky Full of Stars',
      artist: 'Mummy',
      album: 'Ghost Stories',
      albumArt:
          'https://www.pngall.com/wp-content/uploads/2016/04/Happy-Person-Free-Download-PNG.png',
      url:
          "https://storage.googleapis.com/sogslullabies/Mouj%20Lajyoo%20Adde%20Kaleo%20-%20Kashmiri%20Lori%20(1).mp3"),
];

class SongApiClient {
  Future<List<Song>> getSongs() async {
    return Future.value(songs);
  }

  Future<List<Song>> getSongsFromURL() async {
    // make http call
    // convert to songs

    return Future.value(songs);
  }

  Future<List<Song>> getSongsByTab(String tab) async {
    List<Song> songs = await getSongs();
    if ( tab == ""){
      return Future.value(songs);
    }
    else{
      return Future.value(songs.where((element) => element.tab == tab).toList());
    }
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
  return apiClient.getSongsByTab("");
});
