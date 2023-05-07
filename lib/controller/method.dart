import 'package:flutter/material.dart';

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => destination),
    (Route<dynamic> route) => false,
  );
}
