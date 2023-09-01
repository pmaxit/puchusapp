// define app state for songs playing, pause and song id
// Path: lib/data/states.dart
// import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:oneui/bloc/custom_login_provider.dart';
import 'package:oneui/services/firestore_database.dart';

import '../models/api.dart';
import '../models/models.dart';

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
  final UserModel? user;
  final List<Story> stories;
  final List<Post> posts;
  final List<Journal> journals;
  bool? resetSong;

  AppState(
      {required this.songs,
      this.currentSong,
      required this.isPlaying,
      this.previousSong,
      this.rewiredPercentage = 0,
      this.victoryDays = 0,
      this.currentGoal = 1,
      this.startDate,
      this.finalGoal = 21,
      this.user,
      this.stories = const [],
      this.posts = const [],
      this.journals = const [],
      this.resetSong = false});

  factory AppState.initial() {
    // create new app state
    return AppState(
      songs: [],
      currentSong: null,
      isPlaying: false,
      previousSong: null,
      rewiredPercentage: 0,
      victoryDays: 0,
      currentGoal: 1,
      // previous day
      startDate: DateTime.now().subtract(const Duration(days: 0)),
      finalGoal: 21,
    );
  }

  // copyWith
  AppState copyWith(
      {List<Song>? songs,
      bool? isPlaying,
      Song? currentSong,
      Song? previousSong,
      int? rewiredPercentage,
      int? victoryDays,
      DateTime? startDate,
      int? currentGoal,
      int? finalGoal,
      bool? resetSong}) {
    return AppState(
        songs: songs ?? this.songs,
        isPlaying: isPlaying ?? this.isPlaying,
        currentSong: currentSong ?? this.currentSong,
        previousSong: previousSong ?? this.previousSong,
        rewiredPercentage: rewiredPercentage ?? this.rewiredPercentage,
        victoryDays: victoryDays ?? this.victoryDays,
        startDate: startDate ?? this.startDate,
        currentGoal: currentGoal ?? this.currentGoal,
        finalGoal: finalGoal ?? this.finalGoal,
        resetSong: resetSong ?? this.resetSong);
  }

      // toJson
    Map<String, dynamic> toJson() {
      return {
        "state": {
          "victoryDays": victoryDays,
          "rewiredPercentage": rewiredPercentage,
          "currentGoal": currentGoal,
          "startDate": startDate.toString(),
          "finalGoal": finalGoal,
        }
      };
    }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  void setup() async {
    calculateVictoryDays();
    calculateRewiredPercentage();
  }

      // toJson
    Map<String, dynamic> toJson() {
      return {
        "state": {
          "victoryDays": victoryDays,
          "rewiredPercentage": rewiredPercentage,
          "currentGoal": currentGoal,
          "startDate": startDate,
          "finalGoal": finalGoal,
        }
      };
    }

  void calculateVictoryDays() {
    // difference between current date and start date
    int victoryDays = state.victoryDays;
    print("victoryDays $victoryDays ${state.finalGoal} ${state.currentGoal} ");
    if (victoryDays > state.finalGoal) {
      victoryDays = state.finalGoal;
    } else if (victoryDays >= state.currentGoal) {
      state = state.copyWith(
          victoryDays: victoryDays, currentGoal: victoryDays + 3);
    } else {
      state = state.copyWith(victoryDays: victoryDays);
    }
  }

  void selectFirstSong() {
    state = state.copyWith(currentSong: state.songs[0]);
  }

  void calculateRewiredPercentage() {
    // difference between current date and start date
    int rewiredPercentage = (state.victoryDays / state.finalGoal * 100).round();
    state = state.copyWith(rewiredPercentage: rewiredPercentage);
  }

  void updateVictoryDays(String text) {
    if (text.isNotEmpty && text == "yes") {
      state = state.copyWith(victoryDays: state.victoryDays + 1);
    } else if (text.isNotEmpty && int.tryParse(text) != null) {
      state = state.copyWith(victoryDays: int.parse(text));
    } else if (text.isNotEmpty && text == "no") {
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
      currentSong: currentSong,
    );
  }

  void pauseSong(Song currentSong) {
    state = state.copyWith(
      isPlaying: false,
      currentSong: currentSong,
    );
  }

  void toggleSong(Song? currentSong) {
    bool isPlayingUpdate = state.isPlaying;
    // if (currentSong == state.currentSong || state.isPlaying == false) {
    //   isPlayingUpdate = ;
    // }
    print(
        "state ispLaying ${state.isPlaying} isPlayingUpdate $isPlayingUpdate");
    state = state.copyWith(
      isPlaying: !isPlayingUpdate,
      currentSong: currentSong,
    );
  }

  void setNewSong(Song? newSong) {
    if (newSong != currentSong) {
      state = state.copyWith(currentSong: newSong, resetSong: true);
    }
  }

  void updateState(Map<String, dynamic> newState){
    state = state.copyWith(
      rewiredPercentage: newState['rewiredPercentage'],
      victoryDays: newState['victoryDays'],
      currentGoal: newState['currentGoal'],
      startDate: DateTime.parse(newState['startDate']),
      finalGoal: newState['finalGoal'],
    );
  }

  Song? get currentSong => state.currentSong;
  bool get isPlaying => state.isPlaying;
  List<Song> get songs => state.songs;
  Song? get previousSong => state.previousSong;
  int get rewiredPercentage => state.rewiredPercentage;
  int get victoryDays => state.victoryDays;
  int get currentGoal => state.currentGoal;
  DateTime? get startDate => state.startDate;
  int get finalGoal => state.finalGoal;
  UserModel? get user => state.user;
  List<Story> get stories => state.stories;
  List<Post> get posts => state.posts;
  List<Journal> get journals => state.journals;
}



// appStateProvider
final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  final songs = ref.watch(allSongsList);
  final currentState = ref.read(currentStateProvider);

  // get user data 
  // get all the songs

  // setting up the state
  AppStateNotifier appStateNotifier = AppStateNotifier()..setup();

  // get songs from songs API

  // add new songs
  songs.whenData((songsList) {
    appStateNotifier
      ..addSongs(songsList)
      ..selectFirstSong();
  });

  // get current state
  currentState.whenData((currentState) {
    if (currentState.isNotEmpty) {
          appStateNotifier.updateState(currentState);
  }
  });

  return appStateNotifier;
});

// provider for journals based on passwordstate
final journalsProvider = StreamProvider<List<Future<Journal>>>((ref) {
  final customLoginState = ref.watch(customLoginProvider);
  final firebaseDB = ref.watch(firebaseDBProvider);

  if (customLoginState.status == CustomLoginStatus.privateSpace) {
    // get the private space journals
    return firebaseDB.noteStream();
  } else {
    return Stream.value([]);
  }
});

// get Current status provider
final currentStateProvider = StreamProvider<Map<String,dynamic>>((ref) {
  final firebaseDB = ref.watch(firebaseDBProvider);

  return firebaseDB.getCurrentState();
});

