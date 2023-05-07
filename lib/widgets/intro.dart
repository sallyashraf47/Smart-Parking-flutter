
import 'package:flutter/material.dart';



Widget circle(double size) {
  double screenHeight = 0;

  return Container(
    height: screenHeight / size,
    width: screenHeight / size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  );
}


Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    //keyboardType: textInputType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {

  Size size = MediaQuery.of(context).size;
  return  Container(
      margin: const EdgeInsets.symmetric(
      vertical: 10),
  width: size.width * 0.8,
  child: ClipRRect(
  borderRadius:
  BorderRadius.circular(29),
  child: ElevatedButton(
      onPressed: () {
        onTap();
      },
  style: ElevatedButton.styleFrom(
  backgroundColor: const     Color.fromARGB(255, 84, 145, 206),
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
      child: Text(
        title,
  style: const TextStyle(
  color: Colors.black,
  fontSize: 17),
      ),
    ),
  ));
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function function;

  const PrimaryButton({Key? key, required this.text, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return  Container(
        margin: const EdgeInsets.symmetric(
            vertical: 10),
        width: size.width * 0.8,
        child: ClipRRect(
        borderRadius:
        BorderRadius.circular(29),
    child: ElevatedButton(

        onPressed: () {
          function();
        },
        style: ElevatedButton.styleFrom(
    backgroundColor:    Color.fromARGB(255, 84, 145, 206),

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
        child: Text(
          text,
        style: const TextStyle(
        color: Colors.black,
        fontSize: 17),
        ),
      ),
    ) );
  }
}




