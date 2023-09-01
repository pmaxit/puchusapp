import 'user_model.dart';

class Story{
  final UserModel user;
  final String imageUrl;
  final bool isViewed;
  String? documentId;

  Story({
    required this.user,
    required this.imageUrl,
    this.isViewed=false,
    this.documentId
  });

  // fromMap
  factory Story.fromMap(Map<String, dynamic> data, String documentId){
    final user = UserModel.fromMap(data['user']);
    final imageUrl = data['imageUrl'] as String;
    final isViewed = data['isViewed'] as bool;

    return Story(
      user: user,
      imageUrl: imageUrl,
      isViewed: isViewed,
      documentId: documentId
    );
  }

  // toMap
  Map<String, dynamic> toMap(){
    return {
      'user': user.uid,
      'imageUrl': imageUrl,
      'isViewed': isViewed,
    };
  }
}