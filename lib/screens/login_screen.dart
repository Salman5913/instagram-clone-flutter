import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/screens/signup_name_screen.dart';
import 'package:instagram/utils/utils.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/widgets/text_filed_inputs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false; //check if the screen  is Loading when sign in
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //login user ,this function is passed in onTap login button
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      //Navigate to responsive layout accordung to width
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      await showSnackBar(res, context);
      //showSnackBar function is made in utils.dart
    }
    setState(() {
      isLoading = false;
    });
  }

  void naviagateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(child: Container(), flex: 2),
          //svg image for logo
          SvgPicture.asset(
            'assets/images/Instagram-Glyph-Color-Logo.wine.svg',
            height: 95,
          ),
          const SizedBox(
            height: 64,
          ),
          //text field input for email
          TextFieldInput(
            textInputPadding: EdgeInsets.all(22),
            labelText: Text('Email', style: TextStyle(color: Colors.grey)),
            textEditingController: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 24,
          ),

          //text field input for password
          TextFieldInput(
            textInputPadding: EdgeInsets.all(22),
            isPassword: true,
            labelText: Text('Password', style: TextStyle(color: Colors.grey)),
            textEditingController: _passwordController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 24,
          ),
          //login button
          GestureDetector(
            onTap: loginUser,
            child: Container(
              height: 64,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: ShapeDecoration(
                color: blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            child:
                const Text('Forgot password?', style: TextStyle(fontSize: 15)),
          ),
          Flexible(child: Container(), flex: 2),
          //transitioning to signup
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: naviagateToSignUp,
              child: const Text('Create new account',
                  style: TextStyle(color: Colors.black87)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            'assets/images/Meta_Platforms-Logo.wine.svg',
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      )),
    );
  }
}
