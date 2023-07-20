// define app state for songs playing, pause and song id
// Path: lib/data/states.dart
// import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'api.dart';
import 'song.dart';

class AppState {
  final List<Song> songs;
  final bool isPlaying;
  final Song? currentSong;
  final Song? previousSong;

  AppState({
    required this.songs,
    this.currentSong,
    required this.isPlaying,
    this.previousSong,
  });

  factory AppState.initial() => AppState(
        songs: [],
        currentSong: null,
        isPlaying: false,
      );
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  void addSongs(List<Song> songs) {
    state = AppState(
      songs: songs,
      isPlaying: false,
      currentSong: songs[0],
    );
  }

  void playSong(Song currentSong) {
    state = AppState(
      songs: state.songs,
      isPlaying: true,
      currentSong: currentSong,
    );
  }

  void pauseSong(Song currentSong) {
    state = AppState(
      songs: state.songs,
      isPlaying: false,
      currentSong: currentSong,
    );
  }

  void toggleSong(Song? currentSong) {
    bool isPlayingUpdate = state.isPlaying;
    if (currentSong == state.currentSong || state.isPlaying == false) {
      isPlayingUpdate = !isPlayingUpdate;
    }
    state = AppState(
      songs: state.songs,
      isPlaying: isPlayingUpdate,
      currentSong: currentSong,
    );
  }

  void copyWith({
    List<Song>? songs,
    bool? isPlaying,
    Song? currentSong,
  }) {
    print('updating app state ${currentSong!.songId}');
    state = AppState(
        songs: songs ?? state.songs,
        isPlaying: isPlaying ?? state.isPlaying,
        currentSong: currentSong ?? state.currentSong,
        previousSong: state.currentSong);
  }

  Song? get currentSong => state.currentSong;
  bool get isPlaying => state.isPlaying;
  List<Song> get songs => state.songs;
  Song? get previousSong => state.previousSong;
}

// appStateProvider
final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  // get songs from songs API
  AppStateNotifier appStateNotifier = AppStateNotifier();

  final songs = ref.watch(songsProvider);
  songs.whenData((value) => appStateNotifier.addSongs(value));

  return appStateNotifier;
});
