import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/widgets/PageTitleBar.dart';
import 'package:finalproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../controller/method.dart';
import '../timer/timer.dart';

class Rate extends StatefulWidget {
  const Rate({super.key});

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  double? rate;
  var user = FirebaseAuth.instance.currentUser?.uid;

  void addRating() {
    FirebaseFirestore.instance.collection('rating').doc(user).set({
      'Rate': rate,
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
        //  appBar: AppBar(title: Text("smart")),
            //  drawer: Drawer(
            //  child: SingleChildScrollView(
            //  child: Container(
            //  child: Column(
            //  children: [
            //    HomePage(),
            //],
            //),

            body: SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                    child: Stack(children: [
                  Center(
                      child: Lottie.network(
                          "https://assets2.lottiefiles.com/packages/lf20_ryawvk4g.json",
                          height: 280)),
                  const PageTitleBar(title: 'Rating Smart Parking'),
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
                                  height: 50,
                                ),
                                Form(
                                    child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Enjoying Smart Parking?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          // fontFamily: ,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 9,
                                    ),
                                    const Text(
                                        "Tap a star to rate it in the App Store."),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        rate=rating;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            addRating();
                                            showDialog(context: context, builder: (context){

                                              return const AlertDialog(content: Text("Thank you\n\n your rate is submitted",textAlign: TextAlign.center),icon: Icon(Icons.tag_faces_rounded,color: Colors.yellow,size:50),);

                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 84, 145, 206),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 20),
                                              textStyle: const TextStyle(
                                                  letterSpacing: 2,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans')),
                                          child: const Text(
                                            "submit",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              pushReplacement(context, const HomePage());

                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 84, 145, 206),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 20),
                                                textStyle: const TextStyle(
                                                    letterSpacing: 2,
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans')),
                                            child: const Text(
                                              "cancel",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 190,
                                    ),
                                  ],
                                ))
                              ])))
                ])))));
  }
}

_build() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 100),
    child: Text(
      "How Was your Ride?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
