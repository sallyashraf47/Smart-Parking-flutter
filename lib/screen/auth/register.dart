import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/controller/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/method.dart';
import '../../widgets/PageTitleBar.dart';
import '../../widgets/RoundedInputField.dart';
import '../Verifying_Email.dart';
import '../../widgets/intro.dart';
import '../signin/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  // final _productSizesList = [
  // "employee OR student",
  //"vistor",
  //];

  var user = FirebaseAuth.instance.currentUser?.uid;
  Color blue = const Color(0xff8cccff);
  String countryDial = "+962";

  String? _selectedVal;
  var formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool showSpinner = false;

  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  saveSignIn(bool signIn) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('signIn', signIn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
                child: Image.network(
                    "https://img.freepik.com/premium-vector/online-registration-sign-up-login-account-smartphone-app-user-interface-with-secure-password-mobile-application-ui-web-banner-access-cartoon-people-vector-illustration_2175-1060.jpg?w=2000",
                    height: 300)),
            const PageTitleBar(title: 'Create New Account'),
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
                    Form(
                        child: Column(children: [
                          RoundedInputField(
                              text: " UserName",
                              icon: Icons.person_outline,
                              isPasswordType: false,
                              controller: userName),
                          RoundedInputField(
                              text: " Email",
                              icon: Icons.email,
                              isPasswordType: false,
                              controller: email),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color(0xfffeeeee4),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: IntlPhoneField(
                                controller: phoneNumber,
                                disableLengthCheck: true,
                                showCountryFlag: false,
                                showDropdownIcon: false,
                                initialValue: countryDial,
                                onCountryChanged: (country) {
                                  setState(() {
                                    countryDial = "+${country.dialCode}";
                                  });
                                },
                                decoration: const InputDecoration(
                                    suffixIcon:
                                    Icon(Icons.phone, color: Colors.white),
                                    labelText: 'Phone',
                                    labelStyle: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black),

                                    // filled: true,
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                    //  fillColor: Colors.white,
                                    border: InputBorder.none)),
                          ),
                          RoundedInputField(
                              text: " Password",
                              icon: Icons.lock_outline,
                              isPasswordType: true,
                              controller: password),


                          const SizedBox(
                            height: 10,
                          ),

                          loading
                              ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ))
                              : PrimaryButton(
                            function: () {
                              saveSignIn(true);
                              register();
                              // signUp();
                            },
                            text: 'Sign up',
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                child: const Text("Login here"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignInScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ]))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void register() {
    print(_selectedVal);
    if (userName.text.isNotEmpty &&
        password.text.isNotEmpty &&
        phoneNumber.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty) {

        if (phoneNumber.text.length == 10) {
          if (password.text.length >= 6 || confirmPassword.text.length >= 6) {
            setState(() {
              loading = true;
            });
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
                .then((value) {
              print(value.user?.uid);
              print('--------------------------------');
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(value.user?.uid)
                  .set({
                "Id": value.user?.uid,
                "Username": userName.text.toString(),
                'Email': email.text.toString(),
                'Phone_number': phoneNumber.text.toString(),
                "Password": password.text.toString(),
                "Type": _selectedVal
              });
            }).then((value) {
              pushAndRemoveUntil(context, const Verifying_Email());
              setState(() {
                loading = false;
              });
            });
          } else {
            Fluttertoast.showToast(
              msg: "Your must be more than 6 character",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: hexStringToColor("1760A9"),
              textColor: Colors.white,
              fontSize: 22.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Your phone must Jordanian number and 10 digits ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: hexStringToColor("1760A9"),
            textColor: Colors.white,
            fontSize: 22.0,
          );
        }

    } else {
      Fluttertoast.showToast(
        msg: "Confirm your information",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: hexStringToColor("1760A9"),
        textColor: Colors.white,
        fontSize: 22.0,
      );
    }
  }


  Future signUp() async {
    try {
      if (email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          userName.text.isNotEmpty &&
          phoneNumber.text.isNotEmpty) {

        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email.text, password: password.text) ;



      } else {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.bottomSlide,
          title: 'Attend  !',
          desc: 'The password is weak',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.bottomSlide,
          title: 'Attend  !',
          desc: 'This Account is Already Exist',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }
}
