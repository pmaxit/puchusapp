class Song {
  int? songId;
  String? title;
  String? artist;
  String? album;
  String? albumArt;
  String url;

  Song(
      {this.title,
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
      String? url}) {
    return Song(
        songId: songId ?? this.songId,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        album: album ?? this.album,
        albumArt: albumArt ?? this.albumArt,
        url: url ?? this.url);
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        songId: json['id'],
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        albumArt: json['albumArt'],
        url: json['url']);
  }
}
