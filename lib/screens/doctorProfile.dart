import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/bookingScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfile extends StatefulWidget {
  final String doctor;

  const DoctorProfile({Key? key, required this.doctor}) : super(key: key);
  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  _launchCaller(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List finalData = [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'doctor')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null && snapshot.data!.size != 0) {
              finalData = [];
              for (var i = 0; i < snapshot.data!.size; i++) {
                if (snapshot.data!.docs[i]['name']
                    .toString()
                    .toLowerCase()
                    .contains(widget.doctor.toString().toLowerCase())) {
                  finalData.add(snapshot.data!.docs[i]);
                }
              }
            }
            finalData.sort((firstDoctor, anotherDoctor) =>
                firstDoctor['name'].compareTo(anotherDoctor['name']));
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                itemCount: finalData.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = finalData[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left_sharp,
                              color: Colors.indigo,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            document['image'],
                            scale: 1,
                          ),
                          //backgroundColor: Colors.lightBlue[100],
                          radius: 80,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          document['name'] ?? 'Not Added',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          document['type'] ?? 'Not Added',
                          style: GoogleFonts.lato(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < document['rating']; i++)
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.indigoAccent,
                                size: 30,
                              ),
                            if (5 - document['rating'] > 0)
                              for (var i = 0; i < 5 - document['rating']; i++)
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.black12,
                                  size: 30,
                                ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          alignment: Alignment.center,
                          child: Text(
                            document['specification'] ?? 'Not Added',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(Icons.place_outlined),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: Text(
                                  document['address'] ?? 'Not Added',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(FlutterIcons.phone_in_talk_mco),
                              const SizedBox(
                                width: 11,
                              ),
                              TextButton(
                                onPressed: () =>
                                    _launchCaller("tel: ${document['phone']}"),
                                child: Text(
                                  document['phone'] != ''
                                      ? document['phone'].toString()
                                      : 'Not Added',
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(FlutterIcons.email_outline_mco),
                              const SizedBox(
                                width: 11,
                              ),
                              TextButton(
                                onPressed: document['email'] != ''
                                    ? () => _launchCaller(
                                        "mailto: ${document['email']}")
                                    : null,
                                child: Text(
                                  document['email'] != ''
                                      ? document['email'].toString()
                                      : 'Not Added',
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(Icons.access_time_rounded),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Working Hours',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              Text(
                                'Today: ',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                document['openHour'] ??
                                    'Not Added' +
                                        " - " +
                                        document['closeHour'] ??
                                    'Not Added',
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.indigo.withOpacity(0.9),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingScreen(
                                    doctorEmail: document['email'],
                                    doctor: document['name'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Book an Appointment',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
