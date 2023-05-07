import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final introductionanimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: introductionanimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_enbtbzma.json'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: Text(
                "Smart Parking",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 91, 177),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "This application helps you to find barking for your  car inside the hashemitey universit",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 13, 84, 155), fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              child: InkWell(
                onTap: () {
                  widget.animationController.animateTo(0.2);
                },
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: const Color(0xff132137),
                  ),
                  child: const Text(
                    "Let's begin",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
