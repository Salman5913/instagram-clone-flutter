import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../resources/firestore_methods.dart';

class CommentCard extends StatefulWidget {
  final postId;
  final snap;
  const CommentCard({super.key, required this.snap, required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(user.photoUrl),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //for username and time if commetn post
                  Row(
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          DateFormat.yMEd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  //comment text
                  Text(widget.snap['comText'])
                ],
              ),
            ),
          ),
          //comment like icon
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LikeAnimation(
                  smallLike: true,
                  isAnimating: widget.snap['comLikes'].contains(user.uid),
                  child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likeComment(
                          user.uid,
                          widget.snap['commentId'],
                          widget.snap['comLikes'],
                          widget.postId);
                    },
                    icon: widget.snap['comLikes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            size: 19,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_outline,
                            size: 19,
                          ),
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    widget.snap['comLikes'].length.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
