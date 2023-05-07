import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finalproject/screen/auth/register.dart';
import 'package:finalproject/screen/forget/forget.dart';
import 'package:finalproject/screen/search/search_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/PageTitleBar.dart';
import '../../widgets/RoundedInputField.dart';
import '../../widgets/drawer.dart';
import '../../widgets/intro.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();


  login() async {
    try {
       FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text)
          .then((value) {
        saveSignIn(true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage()));
      }).onError((error, stackTrace) {
        print(error)
;        Fluttertoast.showToast(
          msg: "Email OR password not correct",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: hexStringToColor("1760A9"),
          textColor: Colors.white,
          fontSize: 22.0,
        );
      });
    }  catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
                child: Stack(children: [
              /* ClipPath(
                clipper: TsClip2(),
                child: Container(
                  width: double.infinity,
                  height: 400,
                  color: Color.fromARGB(255, 200, 216, 233),
                  child: */
                  Center(
                      child: Lottie.network(
                        "https://assets8.lottiefiles.com/packages/lf20_jcikwtux.json",
                        height: 250,
                      )),
              const PageTitleBar(title: 'Login to your account'),
              Padding(
                padding: const EdgeInsets.only(top: 320.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          child: Column(
                            children: [
                              RoundedInputField(
                                  text: "Enter Email",
                                  icon: Icons.email,
                                  isPasswordType: false,
                                  controller: _emailTextController),
                              RoundedInputField(
                                  text: "Enter Password",
                                  icon: Icons.lock_outline,
                                  isPasswordType: true,
                                  controller: _passwordTextController),
                              firebaseUIButton(context, "Log In", () {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text)
                                    .then((value) {
                                  saveSignIn(true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage()));
                                }).onError((error, stackTrace) {
                                  Fluttertoast.showToast(
                                    msg: "Email OR password not correct",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    backgroundColor: hexStringToColor("1760A9"),
                                    textColor: Colors.white,
                                    fontSize: 22.0,
                                  );
                                });
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              signUpOption(),
                              const SizedBox(
                                height: 20,
                              ),
                              forgetPassword(context),
                              const SizedBox(
                                height: 120,
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              )
            ]))));
  }

  saveSignIn(bool signIn) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('signIn', signIn);
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
                color: Color.fromARGB(255, 84, 145, 206),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Opensans'),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
              color: Color.fromARGB(255, 84, 145, 206),
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 13),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyPhone())),
      ),
    );
  }
}
