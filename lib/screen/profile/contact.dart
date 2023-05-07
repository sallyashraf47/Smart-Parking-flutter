import 'package:cloud_firestore/cloud_firestore.dart';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import '../../widgets/PageTitleBar.dart';

//import 'booking.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  String name = '';
  String email = '';
  String phone = '';
  var user = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    getData();
    super.initState();
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
                "https://assets8.lottiefiles.com/packages/lf20_RmZ0bEc0hd.json",
                height: 250,
              )),
              const PageTitleBar(title: 'My Profile'),
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
                          child: ListTile(
                            title: const Text(
                              'Name',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 91, 177),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 91, 177),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            email,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Color.fromARGB(255, 13, 84, 155),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            phone,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ]),
                ),
              )
            ]))));
  }

  getData() async {
    print(user);
    print('*******************');
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((value) {
      setState(() {
        name = value['Username'];
        email = value['Email'];
        phone = value['Phone_number'];
      });
    });
  }
}
