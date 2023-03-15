import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);
  @override
  State<AddPostScreen> createState() {
    return _AddPosrScreenState();
  }
}

class _AddPosrScreenState extends State<AddPostScreen> {
  final _addPostDescriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false; //to show the progress indicator on click to post
  //to select image
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select option'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource
                      .camera); //pickImage function is made in utils.dart
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List? file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Cancel'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _addPostDescriptionController.dispose();
  }

  void uploadPost(String uid, String postImage, String userName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      //uploadPostToStorage method is made to upload post to fireebase storage along with all the perimeters
      String res = await FirestoreMethods().uploadPostToStorage(
        _addPostDescriptionController.text,
        postImage,
        uid,
        userName,
        _file!,
      );
      setState(() {
        _isLoading = false;
      });
      //showSnakcBar function is made in utils.dart
      if (res == 'success') {
        showSnackBar('Posted Successfully', context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //set the image to null to pop the new post screen whenever we want,by setiing condition to the if statement below
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    //if image for post is not selected then show upload options otherwise show post screen
    return _file == null
        ? Center(
            child: GestureDetector(
              onTap: () => _selectImage(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    size: 35,
                  ),
                  const Text('Click to upload')
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'New Post',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.clear_outlined,
                  color: Colors.black,
                ),
                onPressed:
                    clearImage, //clearImage function sets the image to null and remove the new post
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      uploadPost(user.uid, user.photoUrl, user.userName),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _addPostDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Write a caption',
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  ),
                  const Divider()
                ],
              )
            ]),
          );
  }
}
