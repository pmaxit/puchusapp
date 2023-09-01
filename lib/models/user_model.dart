import 'package:uuid/uuid.dart';

class UserModel {
  String uid;
  String? email;
  String? name;
  String? phoneNumber;
  String? photoUrl;
  String? imageUrl;

  UserModel(
      {required this.uid,
      this.email,
      this.name,
      this.phoneNumber,
      this.photoUrl,
      this.imageUrl});

  // FromMap
  factory UserModel.fromMap(Map<String, dynamic> data) {
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
        imageUrl: imageUrl);
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

}