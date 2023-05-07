import 'package:finalproject/screen/history/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/profile/contact.dart';
import '../screen/rate/rate.dart';
import '../screen/search/search_screen.dart';
import '../screen/signin/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.dashboard;

  saveSignIn(bool signIn) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('signIn', signIn);
  }
  saveSearch(bool search) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('search', search);
  }
  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = const Search();
    } else if (currentPage == DrawerSections.contacts) {
      container = const profile();
    } else if (currentPage == DrawerSections.events) {
      container = const History();
    } else if (currentPage == DrawerSections.rate) {
      container = const Rate();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 84, 145, 206),
        title: const Text("Smart Parking"),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
    );
    /*return ZoomDrawer(
      mainScreen: mainscreen(),
      menuScreen: menuscreen(),
      //angle: 24,
      //  backgroundColor: Colors.red,
      clipMainScreen: true,

      borderRadius: 24,
      showShadow: true,
    );*/
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.home,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Profile", Icons.people,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "History", Icons.history,
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Rate", Icons.star,
              currentPage == DrawerSections.rate ? true : false),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Expanded(
                  child: Icon(
                    Icons.email,
                    size: 30,
                    color: Color.fromARGB(255, 84, 145, 206),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Sparking@gmail.com",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Expanded(
                  child: Icon(
                    Icons.phone,
                    size: 30,
                    color: Color.fromARGB(255, 84, 145, 206),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "07 7651 1704",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*menuItem(5, "Settings", Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false),*/
          const SizedBox(
            height: 100,
          ),
          InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                saveSignIn(false);
                saveSearch(false);
                SharedPreferences shared =
                    await SharedPreferences.getInstance();
                shared.remove('userBooking').whenComplete(() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                      (route) => false);
                });
              },
              child: const ListTile(
                  leading: Text('Log Out'), trailing: Icon(Icons.logout))),
          // menuItem(6, "LOg Out", Icons.logout,
          //     currentPage == DrawerSections.notifications ? true : false),
          /* Divider(),
          menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(8, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),*/

          const SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected
          ? const Color.fromARGB(255, 166, 199, 232)
          : Colors.transparent,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30.0),
        bottom: Radius.circular(30.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.rate;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color.fromARGB(255, 84, 145, 206),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  rate,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 166, 199, 232),
          //width: 300,
          height: 200,
          child: Lottie.network(
              "https://assets4.lottiefiles.com/private_files/lf30_skwgamub.json"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Smart parking",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              // fontFamily: ,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
