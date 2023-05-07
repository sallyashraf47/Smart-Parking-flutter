import 'package:finalproject/screen/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/PageTitleBar.dart';
import '../../widgets/RoundedInputField.dart';


class HomeAuth extends StatefulWidget {
  const HomeAuth({super.key});

  @override
  State<HomeAuth> createState() => _HomeAuthState();
}

class _HomeAuthState extends State<HomeAuth> {
  bool loading = false;
  final _productSizesList = [
    "employee OR student",
    "vistor",
  ];
  String otpPin = " ";
  String countryDial = "+962";
  String verID = " ";
  TextEditingController phoneNumber = TextEditingController();
  int screenState = 0;
  Color blue = const Color(0xff8cccff);

  String? _selectedVal;
  var formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool showSpinner = false;

  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: screenState == 0 ? SignUpScreen() : verifyOtp(),
          ),
        ),
      ),
    );
  }



  Widget verifyOtp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
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
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "We just sent a code to ",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: countryDial + phoneNumber.text,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "\nEnter the code here and we can continue!",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          PinCodeTextField(
            appContext: context,
            length: 6,
            onChanged: (value) {
              setState(() {
                otpPin = value;
              });
            },
            pinTheme: PinTheme(
              activeColor: blue,
              selectedColor: blue,
              inactiveColor: Colors.black26,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Didn't receive the code? ",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        screenState = 0;
                      });
                    },
                    child: Text(
                      "Resend",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
              //      primary: hexStringToColor("1760A9"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  //verifyOTP();
                },
                child: const Text("Verify Phone Number")),
          ),
        ],
      ),
    );
  }
}
