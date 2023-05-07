

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static int? verfiy;

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();

  TextEditingController email = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+20";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/forget.jpg',
                fit: BoxFit.fitWidth,
                width: 340,
                height: 240,
              ),
              //   logoWidget('assets/images/forget.jpg'),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Email Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your Email without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //      primary: hexStringToColor("1760A9"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);

                      print('*****************************');
                      print(AuthorizationStatus.authorized);
                      print('*****************************');
                      showDialog(context: context, builder: (context){

                        return const AlertDialog(content: Text("Password  reset link sent!Check your email"),);

                      });
                    },
                    child: const Text("Send Email")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
