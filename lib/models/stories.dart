class User{
  final String name;
  final String imageUrl;

  User({
    required this.name,
    required this.imageUrl
  });

}

class Story{
  final User user;
  final String imageUrl;
  final bool isViewed;

  Story({
    required this.user,
    required this.imageUrl,
    this.isViewed=false
  });
}