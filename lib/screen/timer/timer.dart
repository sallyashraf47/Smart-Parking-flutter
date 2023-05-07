import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:finalproject/screen/timer/appbar.dart';
import 'package:finalproject/screen/timer/clock.dart';
import 'package:finalproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../controller/method.dart';
import '../../widgets/intro.dart';
import '../rate/rate.dart';

class HomeTimer extends StatefulWidget {
  const HomeTimer({super.key});

  @override
  State<HomeTimer> createState() => _HomeTimerState();
}

class _HomeTimerState extends State<HomeTimer> {
  CustomTimerController controller = CustomTimerController();

  var format = DateFormat("HH:mm");
  late DateTime timeNow;
  late DateTime differenceTime;
  late DateTime end;
  late Duration duration;
  late int dura;

  bool isAfter = false;
  bool isBefore = false;
  String? faculty;
  String? time;
  String? location;
  String? sTime;
  List iAfter = [];
  List iBefore = [];
  List ifDura = [];
  List ibDura = [];
  List length = [];
  saveSearch(bool search) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('search', search);
  }

  void setCounter(String endTime) {
    var x = DateTime.now();
    var formattedDate = DateFormat('kk:mm').format(x);
    timeNow = format.parse(formattedDate);
    end = format.parse(endTime);
    showNotification(end);
    print('Now    $timeNow');
    if (timeNow.isBefore(end)) {
      isAfter = false;
      isBefore = true;
      iAfter.add(isAfter);
      iBefore.add(isBefore);
      duration = end.difference(timeNow);
      ibDura.add(duration);
      print('now before end ');
    } else if (timeNow.isAfter(end)) {
      isBefore = false;
      isAfter = true;
      iAfter.add(isAfter);
      iBefore.add(isBefore);
      var xx = timeNow.difference(end).inMinutes;
      if ((60 - xx >= 0) && (60 - xx) <= 60) {
        dura = 60 - xx;
        ifDura.add(dura);
      } else {
        dura = 0;
        ifDura.add(dura);
      }

      print('end after now');
    } else {
      print('difference = ${end.difference(timeNow)}');
    }
  }

  Future getBook() async {
    var prefs = await SharedPreferences.getInstance();
    faculty = prefs.getString('faculty') ?? "";
    time = prefs.getString('time') ?? "";
    sTime = prefs.getString('sTime') ?? "";
    location = prefs.getString('location') ?? "";

    return time;
  }

  Future getDataUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('userBooking') ?? "";
    List cdd = json.decode(encodedMap);
    length = cdd;
    cdd.forEach((element) {
      setCounter(element['time']);

      print(element['time']);
    });
    print('--------');
    return cdd;
  }

  update(String f, String t, String p) async {
    var updatePosition = FirebaseFirestore.instance
        .collection('parking')
        .doc(f)
        .collection('Time')
        .doc(t);
    updatePosition.set(
      {
        'position': {p: true}
      },
      SetOptions(merge: true),
    );

    FirebaseFirestore.instance
        .collection('parking')
        .doc(f)
        .collection('Time')
        .doc(t)
        .get()
        .then((value) {
      var updatePosition = FirebaseFirestore.instance
          .collection('parking')
          .doc(f)
          .collection('Time')
          .doc(t);
      updatePosition.set(
        {'count': value.data()!['count'] - 1},
        SetOptions(merge: true),
      );
    });
  }

  DateTime dateTime = DateTime.now();

  showNotification(DateTime dateTime) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    // flutterLocalNotificationsPlugin.show(
    //     01, _title.text, _desc.text, notificationDetails);

    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
        01, 'End Booking', 'end', scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? user = FirebaseAuth.instance.currentUser?.uid;
  String name = '';

  getData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((value) {
      setState(() {
        name = value['Username'];
      });
    });
  }

  ScrollController controller1 = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (dataYouNeedToUseWhenNotificationIsClicked) {},
    );
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    print('time $time');
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffE3EDF7),
        body: FutureBuilder(
          future: getDataUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data as List;
              print('Leangth ${data.length}');
              return Column(children: [
                const Appbars(),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: DateTime.now().hour <= 12
                            ? 'Good Morning, \n  $name,  '
                            : 'Good Evening, \n  $name,  ',
                        style: const TextStyle(
                          height: 1.3,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const TextSpan(
                        text: 'Have a nice day.!',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                const ClockView(),
                Expanded(
                    // height: length.length * 260,
                    child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Faculty  :',
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Time  :',
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Location  :',
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    length[index]['faculty'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    length[index]['sTime'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    length[index]['location'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      iBefore[index]
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'The remaining time \n          until the reservation begins',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTimer(
                                    controller: controller,
                                    begin: ibDura[index],
                                    end: const Duration(seconds: 0),
                                    onChangeState: (CustomTimerState cc) {
                                      if (cc.name == 'finished') {
                                        setState(() {
                                          isBefore = false;
                                          isAfter = true;
                                        });
                                      }
                                    },
                                    builder: (remaining) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.hours,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.minutes,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.seconds,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );

                                      Text(
                                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                          style:
                                              const TextStyle(fontSize: 24.0));
                                    }),
                              ],
                            )
                          : Container(),
                      iAfter[index]
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'The remaining time \n          until the end of the reservation',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTimer(
                                    controller: controller,
                                    begin: Duration(minutes: ifDura[index]),
                                    end: const Duration(seconds: 0),
                                    onChangeState: (CustomTimerState cc) {
                                      if (cc.name == 'finished') {
                                        update(
                                            data[index]['faculty'],
                                            data[index]['sTime'],
                                            data[index]['location']);
                                        setState(() {
                                          isBefore = false;
                                          isAfter = false;
                                        });
                                      }
                                    },
                                    builder: (remaining) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.hours,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.minutes,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.blueGrey.shade200,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                remaining.seconds,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 35,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      firebaseUIButton(context, "end booking", () async {
                        update(
                            data[index]['faculty'],
                            data[index]['sTime'],
                            data[index]['location']);
                        // if(index==data.length-1){
                        //   saveSearch(false);
                        //   SharedPreferences shared =
                        //       await SharedPreferences.getInstance();
                        //   shared.remove('userBooking').whenComplete(() {
                        //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //         builder: (context) => const rate()));
                        //  }
    //  );
      //                  }
                      }),
                    ],
                  ),
                )),
                MaterialButton(
                    color: Colors.teal,
                    child: const Text('end all Booking'),
                    onPressed: () async {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text:
                          'When you click to stop, your position will be canceled',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () async {
                            length.forEach((element) {
                              update(element['faculty'], element['sTime'],
                                  element['location']);
                            });
                            saveSearch(false);
                            SharedPreferences shared =
                            await SharedPreferences.getInstance();
                            shared.remove('userBooking').whenComplete(() {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const Rate()));
                            });
                          });



                    }),
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
