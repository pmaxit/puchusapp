class Song {
  int? songId;
  String? title;
  String? artist;
  String? album;
  String? albumArt;
  String url;
  String tab;

  Song(
      {required this.tab,
      this.title,
      this.artist,
      this.album,
      this.albumArt,
      required this.url,
      this.songId});

  Song copyWith(
      {int? songId,
      String? title,
      String? artist,
      String? album,
      String? albumArt,
      String? url,
      required String tab}) {
    return Song(
        tab: tab,
        songId: songId ?? this.songId,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        album: album ?? this.album,
        albumArt: albumArt ?? this.albumArt,
        url: url ?? this.url);
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        tab: json['tab'],
        songId: json['id'],
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        albumArt: json['albumArt'],
        url: json['url']);
  }
}
