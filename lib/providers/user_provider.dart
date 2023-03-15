import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import '../resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;
  User get getUser =>
      _user ??
      //To handle the null exception
      User(
          userName: '',
          bio: '',
          email: '',
          followers: [],
          following: [],
          password: '',
          photoUrl: '',
          uid: '');

  Future<void> refereshUser() async {
    try {
      User? user = await _authMethods.getUserDetailsFromFirebase();

      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        // Handle null user appropriately
        print("Error: User is null.");
      }
      notifyListeners();
    } catch (error) {
      // Handle error appropriately
      print("Error fetching user details: ${error.toString()}");
    }
  }
}
