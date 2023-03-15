import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/screens/login_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../utils/widgets/text_filed_inputs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image; //global variable to store an image
  bool isLoading = false; //Loading when signup
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource
        .gallery); //pickImage method is made in utils.dart file to pick an image
    setState(() {
      _image = img;
    });
  }

//to signup user this function is passed in onTap signup button
  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      userName: _userNameController.text,
      password: _passwordController.text,
      file: _image!,
      bio: _bioController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context); //showSnackBar funvtion is made in utils.dart
    } else {
      //Navigate to responsive layout accordung to width
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

//Navigate to login id user already have an account work on Already have an account? onTap
  void naviagateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(child: Container(), flex: 1),

          //SVG picture for instagram logo
          SvgPicture.asset(
            'assets/images/Instagram-Glyph-Color-Logo.wine.svg',
            height: 95,
          ),
          SizedBox(
            height: 20,
          ),
          //attention to upload picture
          Stack(
            children: [
              //if _image is not equal to null then it will displayed in circle avatar if it is null then a default image for profile will be displayed
              _image != null
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(_image!),
                      radius: 50,
                    )
                  : const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profile image.png'),
                      radius: 50,
                    ),
              Positioned(
                  bottom: -7,
                  left: 65,
                  child: IconButton(
                      onPressed:
                          selectImage, //this function is made abov to select an image fro gallery

                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.black26,
                      ))),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          //text field input for email
          TextFieldInput(
            textInputPadding: EdgeInsets.all(10),
            labelText: Text('Email', style: TextStyle(color: Colors.grey)),
            textEditingController: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          //text field input for Username
          TextFieldInput(
            textInputPadding: EdgeInsets.all(10),
            labelText: Text('Username', style: TextStyle(color: Colors.grey)),
            textEditingController: _userNameController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          //text field input for Bio
          TextFieldInput(
            textInputPadding: EdgeInsets.all(10),
            labelText: Text(
              'Bio',
              style: TextStyle(color: Colors.grey),
            ),
            textEditingController: _bioController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),

          //text field input for password
          TextFieldInput(
            textInputPadding: EdgeInsets.all(17),
            labelText: Text(
              'Password',
              style: TextStyle(color: Colors.grey),
            ),
            textEditingController: _passwordController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          //Sign up button
          InkWell(
            onTap: signupUser,
            child: Container(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color:
                              primaryColor), //CircularProgressIndicator shows the loading sign while signing up
                    )
                  : const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: ShapeDecoration(
                color: blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Flexible(child: Container(), flex: 2),
          //transitioning to sign in
          Container(
            child: InkWell(
                onTap: naviagateToLogin,
                child: Text('Already have an account?',
                    style: TextStyle(color: Colors.blue))),
          ),
          SizedBox(
            height: 10,
          ),
        ]),
      )),
    );
  }
}
