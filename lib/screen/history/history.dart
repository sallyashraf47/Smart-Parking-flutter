import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String user = FirebaseAuth.instance.currentUser!.uid;
  var format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                  color: Color.fromARGB(255, 84, 145, 206),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 30,
                        left: 0,
                        child: Container(
                          height: 100,
                          width: 300,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                        )),
                    const Positioned(
                        top: 60,
                        left: 20,
                        child: Text(
                          "Your History",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 84, 145, 206),
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user)
                    .collection('report')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ));
                  }
                  if (snapshot.connectionState != ConnectionState.active) {
                    return const Center(child: Text('Connection Error'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ll(
                        title: format
                            .parse(snapshot.data?.docs[index]['date'])
                            .toString(),
                        time: snapshot.data?.docs[index]['time'],
                        collage: snapshot.data?.docs[index]['collage'],
                        pNum: snapshot.data?.docs[index]['position'],
                      ),
                      itemCount: snapshot.data!.size,
                    ),
                  );
                }),
          ],
        ));
  }
}

class ll extends StatelessWidget {
  const ll(
      {Key? key,
      required this.title,
      required this.time,
      required this.collage,
      required this.pNum})
      : super(key: key);
  final String title;
  final String time;
  final String collage;
  final String pNum;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                              width: 5,
                              color: Colors.blue,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  Text(title)
                ],
              )),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            color: Colors.grey,
                            width: 3,
                            height: 200 // if I remove the size it desappear
                            ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomRight: Radius.circular(35),
                        ),
                        color: Color.fromARGB(255, 84, 145, 206)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        Row(children: [
                          const Icon(Icons.timelapse, color: Colors.white),
                          Text(
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              "Time:    $time")
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          const Icon(Icons.emoji_transportation,
                              color: Colors.white),
                          Text(
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              "Collage:    $collage")
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          const Icon(Icons.local_parking_rounded,
                              color: Colors.white),
                          Text(
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              "Parking Number:    $pNum")
                        ])
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
