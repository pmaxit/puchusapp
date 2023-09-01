
import 'package:oneui/models/user_model.dart';

class Song {
  UserModel user;
  int? songId;
  String? title;
  String? artist;
  String? album;
  String? albumArt;
  String url;
  String tab;
  String? documentId;

  Song(
      {required this.tab,
      this.title,
      this.artist,
      this.album,
      this.albumArt,
      required this.url,
      this.songId,
      required this.user,
      this.documentId});

  Song copyWith(
      {int? songId,
      String? title,
      String? artist,
      String? album,
      String? albumArt,
      String? url,
      UserModel? user,
      required String tab}) {
    return Song(
        tab: tab,
        songId: songId ?? this.songId,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        album: album ?? this.album,
        albumArt: albumArt ?? this.albumArt,
        url: url ?? this.url,
        user: user ?? this.user);
  }

  // to Json
  Map<String, dynamic> toMap() => {
        'user': user.uid,
        'tab': tab,
        'id': songId,
        'title': title,
        'artist': artist,
        'album': album,
        'albumArt': albumArt,
        'url': url,
      };

  factory Song.fromMap(Map<String, dynamic> json, String documentId) {
    return Song(
        user: UserModel.fromMap(json['user']),
        tab: json['tab'],
        songId: json['id'],
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        albumArt: json['albumArt'],
        url: json['url'],
        documentId: documentId);
  }

  //toString
  @override
  String toString() {
    return 'Song{songId: $songId, title: $title, artist: $artist, album: $album, albumArt: $albumArt, url: $url, tab: $tab}';
  }

}
