
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/models/user_model.dart';

import 'song.dart';

List<String> tabs = [
  'motivation',
  'Papa',
  'Mummy',
];

var songs = (UserModel user) => [
      Song(
          user: user,
          tab: 'motivation',
          songId: 0,
          title: 'A Sky Full of Stars',
          artist: 'Coldplay',
          album: 'Ghost Stories',
          albumArt:
              'https://www.pngall.com/wp-content/uploads/2016/04/Happy-Person-Free-Download-PNG.png',
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
      Song(
          user: user,
          tab: 'meditation',
          songId: 1,
          title: 'A Sky Full of Stars',
          artist: 'Papa',
          album: 'Ghost Stories',
          albumArt:
              'https://www.pngall.com/wp-content/uploads/2016/04/Happy-Person-Free-Download-PNG.png',
          url:
              "https://storage.googleapis.com/sogslullabies/Mouj%20Lajyoo%20Adde%20Kaleo%20-%20Kashmiri%20Lori%20(1).mp3"),
      Song(
          user: user,
          tab: 'affirmations',
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
  Future<List<Song>> getSongs(UserModel user) async {
    return Future.value(songs(user));
  }

  Future<List<Song>> getSongsFromURL(UserModel user) async {
    // make http call
    // convert to songs

    return Future.value(songs(user));
  }

  Future<List<Song>> getSongsByTab(String tab, UserModel user) async {
    List<Song> songs = await getSongs(user);

    if (tab == "") {
      return Future.value(songs);
    } else {
      return Future.value(songs
          .where((element) => element.tab.toLowerCase() == tab.toLowerCase())
          .toList());
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



final allSongsList = FutureProvider<List<Song>>((ref) async {
  final firebaseDB = ref.watch(firebaseDBProvider);
  final stream = firebaseDB.songsStream();

  
  final List<Song> songsList = [];
  stream.map((events) async {
      for(var event in events){
        final data = await event;
        songsList.add(data);

      }
  }).toList();

  return songsList;
});

final songsByTabProvider =
    FutureProvider.family<List<Song>, String>((ref, tab) async {
  final songsList = ref.watch(allSongsList);
  final List<Song> songsByTab = [];

  songsList.whenData((songs) {
    final t = songs.where((element) => element.tab == tab).toList();
    songsByTab.addAll(t);
  });

  return songsByTab;

});