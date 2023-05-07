import 'package:finalproject/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appbars extends StatefulWidget {
  const Appbars({Key? key}) : super(key: key);

  @override
  State<Appbars> createState() => _AppbarsState();
}

class _AppbarsState extends State<Appbars> {
  saveSearch(bool search) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('search', search);
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70,),

          SizedBox(width: we * 0.60),
        //  const Text("add anthor pooking"),
          const SizedBox(width: 20,),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomePage()));
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffE3EDF7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(2, 2),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(-2, -2),
                    ),
                  ]),
              child: Icon(
                Icons.add,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
