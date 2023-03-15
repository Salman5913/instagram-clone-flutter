import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/widgets/post_card.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/Instagram-Wordmark-Black-Logo.wine.svg',
          height: 36,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.heart,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.facebookMessenger,
              color: Colors.black,
            ),
          )
        ],
        elevation: 0,
      ),
      body: StreamBuilder(
        //getting yhe instance of collection 'posts' from firebase to get all the posts
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            //itemCount will be according to the number of posts
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              //snap variable is defined in post_card.dart,storing the data related to post in snap variable
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
