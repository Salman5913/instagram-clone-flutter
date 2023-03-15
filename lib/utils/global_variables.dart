import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/home_feed_screen.dart';

import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSizze = 600;
List<Widget> homeScreen = [
  HomeFeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Reels videos'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
