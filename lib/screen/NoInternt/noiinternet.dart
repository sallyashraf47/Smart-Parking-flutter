import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';

class Nointernet extends StatelessWidget {
  const Nointernet({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [const
              SizedBox(height: 70,),
              Image.asset(
                'assets/images/no-internet.jpg',
width: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Oops!",
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 40,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "No Internet connection found. \n Check your connection.",
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const MyApp()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 84, 145, 206),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          textStyle: const TextStyle(
                              letterSpacing: 2,
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans')),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
