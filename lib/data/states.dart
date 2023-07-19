// define app state for songs playing, pause and song id
// Path: lib/data/states.dart
// import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SongState {
  final bool isPlaying;
  final int songId;
  // store valuenotifier for that song
  final ValueNotifier<bool> status;

  SongState(
      {required this.isPlaying, required this.songId, required this.status});

  factory SongState.initial() => SongState(
        isPlaying: false,
        songId: 0,
        status: ValueNotifier<bool>(false),
      );
}

// notifier is the API call to change the state

class SongStateNotifier extends StateNotifier<SongState> {
  SongStateNotifier() : super(SongState.initial());

  void playSong(int songId, ValueNotifier<bool> status) {
    state = SongState(isPlaying: true, songId: songId, status: status);
    changeStatus(status.value);
  }

  void pauseSong(int songId, ValueNotifier<bool> status) {
    state = SongState(isPlaying: false, songId: songId, status: status);
    changeStatus(status.value);
  }

  void changeStatus(bool status) {
    if (mounted) {
      state.status.value = status;
    }
  }
}

final appStateProvider = StateNotifierProvider<SongStateNotifier, SongState>(
  (ref) => SongStateNotifier(),
);
