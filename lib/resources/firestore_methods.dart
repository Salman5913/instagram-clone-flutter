import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart' as model;
import '../models/post.dart' as model;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //post Storage method
  Future<String> uploadPostToStorage(String description, String profImage,
      String uid, String userName, Uint8List file) async {
    String res = 'Some errors occurred';
    try {
      //uploadImageToStorage method is defined in storage_methods.dart
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid()
          .v1(); //Uuid is a class from imported package 'uuid' which generates ids v1 generates a unique id with respect to time for every post
      //post variable contains all the data regarding to post
      model.Post post = model.Post(
        description: description,
        uid: uid,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//likepost method
  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      //if like array contains the uid of the user who tapped
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove(
              [uid]), //update the  like array by removing uid
        });
      }
      //if like array does not contains the uid of the user who tapped
      else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion(
              [uid]), //update the  like array by adding uid
        });
      }
    } catch (e) {
      print(e.toString()); //print the error on debug console
    }
  }

//to post comment
  Future<void> postComment(String postId, String comText, String uid,
      String name, String profilePic) async {
    try {
      String commentId = const Uuid().v1();

      model.Comment comment = model.Comment(
        profilePic: profilePic,
        name: name,
        uid: uid,
        comText: comText,
        commentId: commentId,
        datePublished: DateTime.now(),
        comLikes: [],
      );
      if (comText.isNotEmpty) {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comment')
            .doc(commentId)
            .set(
              comment.toJson(),
            );
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

//like comment
  Future<void> likeComment(
      String uid, String commentId, List comLikes, String postId) async {
    try {
      if (comLikes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comment')
            .doc(commentId)
            .update({
          'comLikes': FieldValue.arrayRemove(
            [uid],
          )
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comment')
            .doc(commentId)
            .update({
          'comLikes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> deleteComment(String commentId) async {
  //   try {
  //     await _firestore.collection('posts').doc(commentId).delete();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> folloUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]) //remove followers
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove(
              [followId]) //remove followers from following
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]) //add followers
        });
        await _firestore.collection('users').doc(uid).update({
          'following':
              FieldValue.arrayUnion([followId]) //add followers to following
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
