// define app state for songs playing, pause and song id
// Path: lib/data/states.dart
// import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/api.dart';
import '../data/song.dart';


class AppState {
  final List<Song> songs;
  final bool isPlaying;
  final Song? currentSong;
  final Song? previousSong;

  int rewiredPercentage;
  int victoryDays;
  int currentGoal;
  int finalGoal;
  final DateTime? startDate;

  AppState({
    required this.songs,
    this.currentSong,
    required this.isPlaying,
    this.previousSong,
    this.rewiredPercentage = 0,
    this.victoryDays = 0,
    this.currentGoal = 1,
    this.startDate,
    this.finalGoal = 21
  
  });

  factory AppState.initial() => AppState(
        songs: [],
        currentSong: null,
        isPlaying: false,
        previousSong: null,
        rewiredPercentage: 0,
        victoryDays: 0,
        currentGoal: 1,
        // previous day 
        startDate: DateTime.now().subtract(Duration(days: 0)),
      );

  // copyWith
  AppState copyWith({
    List<Song>? songs,
    bool? isPlaying,
    Song? currentSong,
    Song? previousSong,
    int? rewiredPercentage,
    int? victoryDays,
    DateTime? startDate,
    int? currentGoal,
  }) {
    return AppState(
      songs: songs ?? this.songs,
      isPlaying: isPlaying ?? this.isPlaying,
      currentSong: currentSong ?? this.currentSong,
      previousSong: previousSong ?? this.previousSong,
      rewiredPercentage: rewiredPercentage ?? this.rewiredPercentage,
      victoryDays: victoryDays ?? this.victoryDays,
      startDate: startDate ?? this.startDate,
      currentGoal: currentGoal ?? this.currentGoal,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  void calculateVictoryDays(){
    // difference between current date and start date
    int victoryDays = state.victoryDays;
    print("victoryDays $victoryDays ${state.finalGoal} ${state.currentGoal} ");
    if(victoryDays > state.finalGoal){
      victoryDays = state.finalGoal;
    }
    else if(victoryDays >= state.currentGoal){
      state = state.copyWith(victoryDays: victoryDays, currentGoal: victoryDays + 3);
    }
    else{
      state = state.copyWith(victoryDays: victoryDays);
    }
  }

  void selectFirstSong(){
    state = state.copyWith(currentSong: state.songs[0]);
  }

  void calculateRewiredPercentage(){
    // difference between current date and start date
    int rewiredPercentage = (state.victoryDays/state.finalGoal * 100).round();
    state = state.copyWith(rewiredPercentage: rewiredPercentage);
  }


  void updateVictoryDays(String text){


    if(text.isNotEmpty  && text == "yes"){
      
      state = state.copyWith(victoryDays: state.victoryDays + 1);
    }
    else if(text.isNotEmpty && int.tryParse(text) != null ){
      state = state.copyWith(victoryDays: int.parse(text));
    }
    else if(text.isNotEmpty && text == "no"){
      state = state.copyWith(victoryDays: 0);
    }

    calculateVictoryDays();
    calculateRewiredPercentage();

  }

  void addSongs(List<Song> songs) {
    state = state.copyWith(songs: songs);
  }

  void playSong(Song currentSong) {
    state = state.copyWith(
      isPlaying: true,
      currentSong: currentSong,);
  }

  void pauseSong(Song currentSong) {
    state = state.copyWith(
      isPlaying: false,
      currentSong: currentSong,);
  }

  void toggleSong(Song? currentSong) {
    bool isPlayingUpdate = state.isPlaying;
    if (currentSong == state.currentSong || state.isPlaying == false) {
      isPlayingUpdate = !isPlayingUpdate;
    }
    state = state.copyWith(
      isPlaying: isPlayingUpdate,
      currentSong: currentSong,
    );
    
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
  AppStateNotifier appStateNotifier = AppStateNotifier()..calculateVictoryDays()..calculateRewiredPercentage();

  final songs = ref.watch(songsProvider);
  songs.whenData((value) => appStateNotifier..addSongs(value)..selectFirstSong());

  return appStateNotifier;
});
