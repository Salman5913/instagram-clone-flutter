import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//StorageMethods is is called in auth_method.dart to store image to storage
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage
      .instance; //Firebase storage class to upload images storage
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!
        .uid); //Reference is a class coming from package firebase_storage
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(
        file); //UploadTask is a class coming from package firebase_storage
    TaskSnapshot snap =
        await uploadTask; //TaskSnapshot is a class coming from package firebase_storage
    Future<String> downloadURL = snap.ref
        .getDownloadURL(); //getDownloadURL is a method coming from class Reference
    return downloadURL;
  }
}
