import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/icons.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  //in init state pageController will be settled
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

//navigation to page on tap on navigation bar
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {});
  }

//on change of page
  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context)
        .getUser; //user to get user data from data base
    return Scaffold(
      //PageView handles which page to be viewed with the help of controller
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChange,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: _page == 0
                  ? InstagramIcons().homeIconTapped
                  : InstagramIcons().homeIconUntapped,
              label: ''),
          BottomNavigationBarItem(
              icon: _page == 1
                  ? InstagramIcons().searchIconTapped
                  : InstagramIcons().searchIconUntapped,
              label: ''),
          BottomNavigationBarItem(
              icon: _page == 2
                  ? InstagramIcons().addIconTapped
                  : InstagramIcons().addIconUntapped,
              label: ''),
          BottomNavigationBarItem(
              icon: _page == 3
                  ? InstagramIcons().videoIconTapped
                  : InstagramIcons().videoIconUntapped,
              label: ''),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 15,
              ),
              label: ''),
        ],
        onTap: navigationTapped, //on tap on the navigation bar
        fixedColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
