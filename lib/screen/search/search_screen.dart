import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/screen/timer/timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/method.dart';
import '../../widgets/PageTitleBar.dart';
import '../../widgets/drawer.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<AppExpansionTileState> expansionTile = GlobalKey();
  var format = DateFormat("HH:mm");
  String? selectedDate;
  String selectedItem = 'please choose college';
  String selectedTime = 'please selected Time ';
  String selectedPosition = 'please selected position';
  List<String> data = [];
  bool data1 = false;
  bool data2 = false;
  List<String> time = [];
  List<String> position = [];
  var formattedDate;
  List bookindData = [];

  @override
  void initState() {
    getFaculty();
    super.initState();
  }

  Future getDataUser() async {
    var prefs = await SharedPreferences.getInstance();
    print('//////////////////////////////////////////');
    String? encodedMap = prefs.getString('userBooking') ?? "";
    print('//////////////////////////////////////////');
    print(json.decode(encodedMap));
    List cdd = json.decode(encodedMap);
    print(cdd);
    print('--------');
    return cdd;
  }

  saveUserBooking(List sData) async {
    var prefs = await SharedPreferences.getInstance();
    List dataUser = sData;
    String encodedMap = json.encode(dataUser);
    prefs.setString('userBooking', encodedMap);
  }



  getFaculty() async {
    CollectionReference pp = FirebaseFirestore.instance.collection('parking');
    await pp.get().then((value) => value.docs.forEach((element) {
          setState(() {
            data.add(element.id);
          });
        }));
  }

  getParkingTime() async {
    time.clear();
    var pp = FirebaseFirestore.instance
        .collection('parking')
        .doc(selectedItem)
        .collection('Time')
        .where('count', isLessThan: 7);
    await pp.get().then((value) {
      List allData = value.docs.map((doc) => doc.id).toList();
      for (var element in allData) {
        setState(() {
          time.add(element.toString());
        });
      }
    });
  }

  getParkingLocation() async {
    position.clear();
    var pp = FirebaseFirestore.instance
        .collection('parking')
        .doc(selectedItem)
        .collection('Time')
        .doc(selectedTime);
    await pp.get().then((value) {
      Map example = value.data()!['position'];
      var trueEntries = example.entries.where((MapEntry e) => e.value);
      Map c = Map.fromEntries(trueEntries);
      c.forEach((key, value) {
        position.add(key);
      });
    });
    setState(() {});
  }

  update() async {
    var updatePosition = FirebaseFirestore.instance
        .collection('parking')
        .doc(selectedItem)
        .collection('Time')
        .doc(selectedTime);
    updatePosition.set(
      {
        'position': {selectedPosition: false}
      },
      SetOptions(merge: true),
    );

    FirebaseFirestore.instance
        .collection('parking')
        .doc(selectedItem)
        .collection('Time')
        .doc(selectedTime)
        .get()
        .then((value) {
      var updatePosition = FirebaseFirestore.instance
          .collection('parking')
          .doc(selectedItem)
          .collection('Time')
          .doc(selectedTime);
      updatePosition.set(
        {'count': value.data()!['count'] + 1},
        SetOptions(merge: true),
      );
    });
  }

  saveSearch(bool search) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('search', search);
  }

  addReport() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    var report = FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .collection('report');
    report.add(
      {
        'date': "${DateTime.now()}",
        'collage': selectedItem,
        'time': selectedTime,
        'position': selectedPosition,
      },
    );
  }

  saveBook(String faculty, String time, String location, String sTime) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('time', time);
    prefs.setString('sTime', sTime);
    prefs.setString('faculty', faculty);
    prefs.setString('location', location);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getDataUser(),
        builder: (context, snapshot) {
          return SafeArea(
              child: Scaffold(
                  drawer: HomePage(),
                  body: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: SingleChildScrollView(
                          child: Stack(children: [
                        Center(
                            child: Lottie.network(
                                "https://assets6.lottiefiles.com/packages/lf20_nhv85sha.json",
                                height: 300)),
                        const PageTitleBar(title: 'Search Parking'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Form(
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 40,
                                              right: 30,
                                              left: 30,
                                            ),
                                            child: ExpansionTile(
                                              collapsedBackgroundColor:
                                                  const Color(0xfffeeeee4),
                                              key: expansionTile,
                                              backgroundColor:
                                                  const Color(0xfffeeeee4),
                                              leading: const Icon(
                                                  Icons.emoji_transportation),
                                              title: Text(selectedItem),
                                              onExpansionChanged: (value) {
                                                // print(value);
                                              },
                                              children: [
                                                for (var i in data) card(i, 1),
                                              ],
                                            ),
                                          ),
                                          data1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    right: 30,
                                                    left: 30,
                                                  ),
                                                  child: ExpansionTile(
                                                    collapsedBackgroundColor:
                                                        const Color(
                                                            0xfffeeeee4),
                                                    backgroundColor:
                                                        const Color(
                                                            0xfffeeeee4),
                                                    leading: const Icon(
                                                        Icons.schedule),
                                                    title: Text(selectedTime),
                                                    onExpansionChanged:
                                                        (value) {
                                                      // print(value);
                                                    },
                                                    children: [
                                                      for (var i in time)
                                                        card(i, 2),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          data2
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    right: 30,
                                                    left: 30,
                                                  ),
                                                  child: ExpansionTile(
                                                    collapsedBackgroundColor:
                                                        const Color(
                                                            0xfffeeeee4),
                                                    backgroundColor:
                                                        const Color(
                                                            0xfffeeeee4),
                                                    leading: const Icon(
                                                        Icons.local_parking),
                                                    title:
                                                        Text(selectedPosition),
                                                    onExpansionChanged:
                                                        (value) {
                                                      // print(value);
                                                    },
                                                    children: [
                                                      for (var i in position)
                                                        card(i, 3),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              width: size.width * 0.8,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(29),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (selectedPosition !=
                                                            'please selected position' &&
                                                        selectedTime !=
                                                            'please selected Time ' &&
                                                        selectedItem !=
                                                            'please choose college') {
                                                      if (snapshot.data ==
                                                          null) {
                                                        bookindData = [];
                                                      } else {
                                                        bookindData =
                                                            snapshot.data;
                                                      }
                                                      bookindData.add({
                                                        "faculty": selectedItem,
                                                        "time": selectedDate,
                                                        "location":
                                                            selectedPosition,
                                                        'sTime': selectedTime
                                                      });

                                                      saveUserBooking(
                                                          bookindData);
                                                      pushAndRemoveUntil(
                                                          context,
                                                          const HomeTimer());
                                                      update();
                                                      addReport();
                                                      saveSearch(true);
                                                    }

                                                    //
                                                    // saveSearch(true);
                                                    // saveBook(
                                                    //     selectedItem,
                                                    //     selectedDate!,
                                                    //     selectedPosition,
                                                    //     selectedTime);
                                                    // update();
                                                    // addReport();
                                                    // pushAndRemoveUntil(
                                                    //     context, const HomeTimer());
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              84,
                                                              145,
                                                              206),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 20),
                                                      textStyle: const TextStyle(
                                                          letterSpacing: 2,
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'OpenSans')),
                                                  child: const Text(
                                                    'start booking',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 130,
                                          ),
                                        ]),
                                      )
                                    ])))
                      ])))));
        });
  }

  Widget card(
    String text,
    int num,
  ) {
    return Card(
      color: Colors.white,
      child: TextButton(
        child: ListTile(title: Text(text)),
        onPressed: () {
          setState(() {
            if (num == 1) {
              selectedItem = text;
              data1 = true;
              getParkingTime();
            } else if (num == 2) {
              selectedTime = text;
              data2 = true;
              List cv = selectedTime.split('');
              String time1 = cv[0];
              String time2 = cv[1];
              if (time2 == ' ') {
                selectedDate = '$time1:00';
              } else {
                selectedDate = '$time1$time2:00';
              }
              formattedDate = format.parse(selectedDate!.trim());
              print(formattedDate);
              print('***');
              getParkingLocation();
            } else {
              selectedPosition = text;
            }
          });

          // print(text);
        },
      ),
    );
  }

  Widget cardparking(
    String text,
  ) {
    return ExpansionTile(
      backgroundColor: const Color.fromARGB(255, 241, 243, 243),
      title: Text(text),
      children: const [],
    );
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

class AppExpansionTile extends StatefulWidget {
  const AppExpansionTile({
    Key? key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final Widget? leading;
  final Widget? title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget>? children;
  final Color? backgroundColor;
  final Widget? trailing;
  final bool? initiallyExpanded;

  @override
  AppExpansionTileState createState() => AppExpansionTileState();
}

class AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  CurvedAnimation? _easeOutAnimation;
  CurvedAnimation? _easeInAnimation;
  ColorTween? _borderColor;
  ColorTween? _headerColor;
  ColorTween? _iconColor;
  ColorTween? _backgroundColor;
  Animation<double>? _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeOut);
    _easeInAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation!);
    _backgroundColor = ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller?.value = 1.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded) {
          _controller?.forward();
        } else {
          PageStorage.of(context)?.writeState(context, _isExpanded);
        }
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor =
        _borderColor?.evaluate(_easeOutAnimation!) ?? Colors.transparent;
    final Color? titleColor = _headerColor?.evaluate(_easeInAnimation!);

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor?.evaluate(_easeOutAnimation!) ??
              Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor?.evaluate(_easeInAnimation!)),
            child: ListTile(
              onTap: toggle,
              leading: widget.leading,
              title: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: titleColor),
                child: widget.title!,
              ),
              trailing: widget.trailing ??
                  RotationTransition(
                    turns: _iconTurns!,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation?.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor?.end = theme.dividerColor;

    _backgroundColor?.end = widget.backgroundColor;

    final bool closed = !_isExpanded && _controller!.isDismissed;
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: (context, W) => _buildChildren(context, W!),
      child: closed ? null : Column(children: widget.children!),
    );
  }
}

_build() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 100),
    child: Text(
      "Search for Parking",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
