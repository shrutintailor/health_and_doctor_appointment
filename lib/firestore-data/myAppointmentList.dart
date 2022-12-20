import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyAppointmentList extends StatefulWidget {
  final bool isDoctor;
  const MyAppointmentList({Key? key, required this.isDoctor}) : super(key: key);

  @override
  State<MyAppointmentList> createState() => _MyAppointmentListState();
}

class _MyAppointmentListState extends State<MyAppointmentList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user;
  var _documentID;
  var _documentEmail;
  var finalData = [];

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  Future<void> deleteAppointment(String email, String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(email.toString())
        .collection('all')
        .doc(docID.toString())
        .delete();
  }

  String _dateFormatter(String _timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
    return formattedDate;
  }

  String _timeFormatter(String _timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(_timestamp));
    return formattedTime;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        deleteAppointment(_documentEmail, _documentID);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete this Appointment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _checkDiff(DateTime _date) {
    var diff = DateTime.now().difference(_date).inHours;
    if (diff > 2) {
      return true;
    } else {
      return false;
    }
  }

  _compareDate(String _date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(_date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  setAppointmentStatus(document, appointmentStatus) async {
    var userAppointment = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(_documentEmail.toString())
        .collection('all')
        .where('doctorEmail', isEqualTo: user.email)
        .where('name', isEqualTo: document['name'])
        .where('status', isEqualTo: 'pending')
        .get();
    DocumentSnapshot userAppointmentDocument = userAppointment.docs[0];
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(userAppointmentDocument['email'])
        .collection('all')
        .doc(userAppointmentDocument.id)
        .set({
      'name': userAppointmentDocument['name'],
      'phone': userAppointmentDocument['phone'],
      'description': userAppointmentDocument['description'],
      'doctor': userAppointmentDocument['doctor'],
      'date': userAppointmentDocument['date'],
      'status': appointmentStatus,
      'email': userAppointmentDocument['email'],
      'doctorEmail': userAppointmentDocument['doctorEmail'],
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection('user_appointments')
        .doc(user.email)
        .collection('all')
        .doc(document.id)
        .set({
      'name': document['name'],
      'phone': document['phone'],
      'description': document['description'],
      'doctor': document['doctor'],
      'date': document['date'],
      'status': appointmentStatus,
      'email': document['email'],
      'doctorEmail': document['doctorEmail'],
    }, SetOptions(merge: true));
  }

  Widget createView(context, finalData) {
    return finalData.length == 0
        ? Center(
            child: Text(
              'No Appointment Scheduled',
              style: GoogleFonts.lato(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: finalData.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = finalData[index];
              if (_checkDiff(document['date'].toDate())) {
                deleteAppointment(document['email'], document.id);
              }
              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () {},
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.isDoctor &&
                                    document['name'] != user.displayName
                                ? document['name']
                                : document['doctor'],
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _compareDate(document['date'].toDate().toString())
                              ? "TODAY"
                              : "",
                          style: GoogleFonts.lato(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        _dateFormatter(document['date'].toDate().toString()),
                        style: GoogleFonts.lato(),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 10, left: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !widget.isDoctor
                                    ? Text(
                                        "Patient name: ${document['name']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Time: ${_timeFormatter(
                                    document['date'].toDate().toString(),
                                  )}",
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            document['status'] == 'pending'
                                ? !widget.isDoctor ||
                                        document['name'] == user.displayName
                                    ? IconButton(
                                        tooltip: 'Delete Appointment',
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black87,
                                        ),
                                        onPressed: () {
                                          _documentEmail = document['email'];
                                          _documentID = document.id;
                                          showAlertDialog(context);
                                        },
                                      )
                                    : Row(
                                        children: [
                                          IconButton(
                                            tooltip: 'Reject Appointment',
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              _documentEmail =
                                                  document['email'];
                                              _documentID = document.id;
                                              await setAppointmentStatus(
                                                  document, 'reject');
                                            },
                                          ),
                                          IconButton(
                                            tooltip: 'Approve Appointment',
                                            icon: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                            onPressed: () async {
                                              _documentEmail =
                                                  document['email'];
                                              _documentID = document.id;
                                              await setAppointmentStatus(
                                                  document, 'approve');
                                            },
                                          ),
                                        ],
                                      )
                                : Text(
                                    document['status'] == 'approve'
                                        ? "Approved"
                                        : "Rejected",
                                    style: GoogleFonts.lato(
                                        color: document['status'] == 'approve'
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    var collectionName = widget.isDoctor ? 'user_appointments' : 'appointments';
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName)
            .doc(user.email.toString())
            .collection('all')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null && snapshot.data!.size != 0) {
            finalData = snapshot.data!.docs;
            finalData.sort((firstDoctor, anotherDoctor) =>
                firstDoctor['date'].compareTo(anotherDoctor['date']));
          }
          return createView(context, finalData);
        },
      ),
    );
  }
}
