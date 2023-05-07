import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  const WelcomeView({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final welcomeFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final welcomeImageAnimation =
        Tween<Offset>(begin: const Offset(4, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: welcomeImageAnimation,
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 350, maxHeight: 350),
                  child: Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_1t8na1gy.json'),
                ),
              ),
              SlideTransition(
                position: welcomeFirstHalfAnimation,
                child: const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 91, 177),
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                child: Text(
                    "Stay organised and live stress-free with Sparking app",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 13, 84, 155),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
