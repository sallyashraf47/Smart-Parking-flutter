
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
   RoundedInputField(
      {Key? key,
      this.text,
      required this.icon,
      required this.controller,
      required this.isPasswordType,})
      : super(key: key);
   late  String? text;
  final IconData icon;
  final TextEditingController controller;
  final bool isPasswordType;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        // cursorColor: Color(0xfffeeeee4),
        controller: controller,
        onSaved: (val){
          text=val;
        },
        obscureText: isPasswordType,
        //keyboardType: textInputType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            hintText: text,
            hintStyle:
                const TextStyle(fontFamily: 'OpenSans', color: Colors.black),
            border: InputBorder.none),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xfffeeeee4),
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
