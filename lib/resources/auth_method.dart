import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; //create object to use methods of class FirebaseAuth from the package of FIrebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //getUserDetailsFromFirebase method is used in user_provider.dart
  Future<model.User> getUserDetailsFromFirebase() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get(); //get current user uid
    return model.User.fromSnap(
        snap); //fromSnap is defined in user.dart model which gets data from firebase according to snap
  }

  //Sign up user
  Future<String> signUpUser(
      {required String email,
      required String userName,
      required String password,
      required Uint8List file,
      required String bio}) async {
    //async method for signup
    String res = 'Some error occured';
    //adding try catch to handle error
    //store user credentials if fields are valid
    try {
      if (email.isNotEmpty ||
          userName.isNotEmpty ||
          password.isNotEmpty ||
          file.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential creds = await _auth.createUserWithEmailAndPassword(
          //with createUserWithEmailAndPassword method user details will be stored using email and password
          email: email,
          password: password,
        );
        print(creds.user!.uid);
        //storing profile picture to firebase storage using StorageMethods class defined in storage_methods.dart
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User user = model.User(
          //this model is defined in the class user
          email: email,
          userName: userName,
          password: password,
          uid: creds.user!.uid,
          photoUrl: photoUrl,
          bio: bio,
          followers: [],
          following: [],
        );
        //storing data in firebase collections
        await _firestore.collection('users').doc(creds.user!.uid).set(
              user.toJson(),
            );
        // //with the method add belo we will get th different uid
        // await _firestore.collection('users').add({
        //   'email': email,
        //   'Username': userName,
        //   'Password': password,
        //   'uid': creds.user!.uid,
        //   'followers': [],
        //   'following': [],
        // });
        res = 'success';
      }
    }
    //error in catch block if credentials are not valid
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some errors occured';
    try {
      if (email.isNotEmpty & password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email,
            password:
                password); //signInWithEmailAndPassword method coming from FirebaseAuth class which signs in the user with email and password
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
