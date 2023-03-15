import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String userName;
  final datePublished;
  final String uid;
  final String
      postId; //to make sure every post has a unique id to avoid overriding
  final String profImage;
  final String postUrl;
  final likes;
  const Post({
    required this.description,
    required this.userName,
    required this.datePublished,
    required this.uid,
    required this.postId,
    required this.profImage,
    required this.postUrl,
    required this.likes,
  });
  //mapping to objects
  Map<String, dynamic> toJson() => {
        'description': description,
        'userName': userName,
        'datePublished': datePublished,
        'uid': uid,
        'postId': postId,
        'profImage': profImage,
        'postUrl': postUrl,
        'likes': likes,
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      userName: snapshot['userName'],
      datePublished: snapshot['datePublished'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
    );
  }
}
