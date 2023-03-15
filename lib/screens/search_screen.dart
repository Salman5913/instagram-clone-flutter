import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUsers = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'search',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('userName',
                      isGreaterThanOrEqualTo: _searchController
                          .text) //isGreaterThanOrEqualTo search for a user that is not exact but have some matching values
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var _data = (snapshot.data as dynamic);
                return ListView.builder(
                  itemCount: _data.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => ProfileScreen(
                                  uid: _data.docs[index]['uid'],
                                )),
                          ),
                        );
                      },
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(_data.docs[index]['photoUrl']),
                          ),
                          title: Text(_data.docs[index]['userName'])),
                    );
                  },
                );
              },
            )
          : StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                var _data = (snapshot.data as dynamic);
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  itemCount: _data.docs.length,
                  crossAxisCount: 3,
                  itemBuilder: (context, index) =>
                      Image.network(_data.docs[index]['postUrl']),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7) == 0 ? 2 : 1, (index % 7) == 0 ? 2 : 1),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            ),
    );
  }
}
