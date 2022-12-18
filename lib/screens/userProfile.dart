import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:health_and_doctor_appointment/firestore-data/appointmentHistoryList.dart';
import 'package:health_and_doctor_appointment/firestore-data/userDetails.dart';
import 'package:health_and_doctor_appointment/screens/userSettings.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user;
  var userData;
  bool isUpdate = false;
  List<Widget> datalist = [];

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  List userLableNames = [
    'Name',
    'Email',
    'Mobile Number',
    'Bio',
    'Birthday',
    'City',
  ];

  List doctorLableNames = [
    'Name',
    'Email',
    'Mobile Number',
    'Specifications',
    'Categories',
    'Birthday',
    'Clinic Address',
    'Opening Hour',
    'Closeing Hour',
  ];

  List userLableValues = [
    'name',
    'email',
    'phone',
    'bio',
    'birthDate',
    'city',
  ];

  List doctorLableValues = [
    'name',
    'email',
    'phone',
    'specification',
    'type',
    'birthDate',
    'address',
    'openHour',
    'closeHour',
  ];

  List displayLableNames = [];
  List displayLableValues = [];

  void createDataList() {
    for (var index = 0; index < displayLableNames.length; index++) {
      if (displayLableValues[index] == 'name' && !isUpdate) {
        continue;
      }
      datalist.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          height: MediaQuery.of(context).size.height / 14,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
          ),
          child: Ink(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text(displayLableNames[index]),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.indigo,
                      ),
                    ),
                    initialValue:
                        userData[displayLableValues[index]] ?? 'Not Added',
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    enabled: isUpdate,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        userData =
            snapshot.data!.data != null ? snapshot.data!.data() as Map : Map();
        displayLableNames = userLableNames;
        displayLableValues = userLableValues;
        if (userData['role'] == 'doctor') {
          displayLableNames = doctorLableNames;
          displayLableValues = doctorLableValues;
        }
        createDataList();
        return Scaffold(
          body: SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.1, 0.5],
                                  colors: [
                                    Colors.indigo,
                                    Colors.indigoAccent,
                                  ],
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 5,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 7),
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(
                                    FlutterIcons.sign_out_alt_faw5s,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/login',
                                            (Route<dynamic> route) => false);
                                    _signOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height / 5,
                              padding: const EdgeInsets.only(top: 75),
                              child: Text(
                                userData['name'] ?? "Not Added",
                                style: GoogleFonts.lato(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.teal[50]!.withOpacity(1),
                                width: 5,
                              ),
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              userData['image'],
                              scale: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...datalist,
                    Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[50],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  color: Colors.green[900],
                                  child: const Icon(
                                    FlutterIcons.history_faw,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Appointment History",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 30,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text('View all'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 35, right: 15),
                                child: const SingleChildScrollView(
                                  child: AppointmentHistoryList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
