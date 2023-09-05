import 'package:uuid/uuid.dart';

class UserModel {
  String uid;
  String? email;
  String? name;
  String? phoneNumber;
  String? photoUrl;
  String? imageUrl;
  String? documentId;

  UserModel(
      {required this.uid,
      this.email,
      this.name,
      this.phoneNumber,
      this.photoUrl,
      this.imageUrl,
      this.documentId});

  // FromMap
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    final uid = data['uid'];
    final email = data['email'];
    final name = data['name'];
    final phoneNumber = data['phoneNumber'];
    final photoUrl = data['photoUrl'];
    final imageUrl = data['imageUrl'];

    return UserModel(
        uid: uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        imageUrl: imageUrl,
        documentId: documentId);
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'imageUrl': imageUrl
    };
  }

  // generate image
  static String generateImageUrl() {
    final uuid = Uuid();
    return 'https://picsum.photos/id/${uuid.v4()}/200/200';
  }

  String toString(){
    return "UserModel(uid: $uid, email: $email, name: $name, phoneNumber: $phoneNumber, photoUrl: $photoUrl, imageUrl: $imageUrl)";
  }

}