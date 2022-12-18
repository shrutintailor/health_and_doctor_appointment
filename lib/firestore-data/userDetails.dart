import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/updateUserDetails.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var user;
  List<Widget> datalist = [];

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  List labelNames = [
    'Name',
    'Email',
    'Mobile Number',
    'Bio',
    'Birthday',
    'City',
  ];

  List value = [
    'name',
    'email',
    'phone',
    'bio',
    'birthDate',
    'city',
  ];

  @override
  void initState() {
    super.initState();
    _getUser();
    createDataList();
  }

  void createDataList() {
    for (var index = 0; index < labelNames.length; index++) {
      datalist.add(
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.5)),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 14),
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    labelNames[index],
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: labelNames[index],
                    ),
                    // userData[value[index]] ?? 'Not Added',
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.active)
            return Center(
              child: CircularProgressIndicator(),
            );
          var userData = snapshot.data!.data != null
              ? snapshot.data!.data() as Map
              : Map();
          return Column(
            children: datalist,
          );
        },
      ),
    );
  }
}
