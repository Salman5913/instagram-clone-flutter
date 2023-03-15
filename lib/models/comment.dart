import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  final String profilePic;
  final String name;
  final String uid;
  final String comText;
  final String commentId;
  final datePublished;
  final comLikes;

  const Comment({
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.comText,
    required this.commentId,
    required this.datePublished,
    required this.comLikes,
  });
  Map<String, dynamic> toJson() => {
        'profilePic': profilePic,
        'name': name,
        'uid': uid,
        'comText': comText,
        'commentId': commentId,
        'datePublished': datePublished,
        'comLikes': comLikes,
      };
  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      profilePic: snapshot['profilePic'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      comText: snapshot['comText'],
      commentId: snapshot['commentId'],
      datePublished: snapshot['datePublished'],
      comLikes: snapshot['comLikes'],
    );
  }
}
