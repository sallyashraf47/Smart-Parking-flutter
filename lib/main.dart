import 'package:finalproject/screen/auth/register.dart';
import 'package:finalproject/screen/introduction_animation/introduction_animation_screen.dart';

import 'package:finalproject/screen/NoInternt/noiinternet.dart';




import 'package:finalproject/screen/timer/timer.dart';


import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

Future checkEnternet() async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    print('Connection Done');
  } else {
    print('Connection failed');
  }
  return result;
}

Future getSignIn() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool('signIn');
}

Future getSearch() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool('search');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: history(),

      home: FutureBuilder(
        future: checkEnternet(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data == true) {
            return FutureBuilder(
                future: getSignIn(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FutureBuilder(
                        future: getSearch(),
                        builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const HomeTimer();
                      } else {
                        return const SignUpScreen();
                      }
                    });
                  } else {
                    return   const IntroductionAnimationScreen();
                  }
                });
          } else {
            return const Nointernet();
          }
        },
      ),
    );
  }
}
