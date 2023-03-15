import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String password;
  final String userName;
  final String uid;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;
  const User(
      {required this.email,
      required this.password,
      required this.userName,
      required this.uid,
      required this.photoUrl,
      required this.bio,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
        'bio': bio,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      userName: snapshot['userName'],
      password: snapshot['password'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
    );
  }
}
