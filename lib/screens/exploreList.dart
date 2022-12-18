import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/doctorProfile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class ExploreList extends StatefulWidget {
  final String type;
  const ExploreList({Key? key, required this.type}) : super(key: key);

  @override
  State<ExploreList> createState() => _ExploreListState();
}

class _ExploreListState extends State<ExploreList> {
  @override
  Widget build(BuildContext context) {
    List finalData = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '${widget.type}s',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'doctor')
              .orderBy('type')
              .startAt([widget.type]).endAt(
                  ['${widget.type}\uf8ff']).snapshots(),
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
                if (snapshot.data!.docs[i]['type']
                    .toString()
                    .toLowerCase()
                    .contains(widget.type.toString().toLowerCase())) {
                  finalData.add(snapshot.data!.docs[i]);
                }
              }
            }
            finalData.sort((firstDoctor, anotherDoctor) =>
                firstDoctor['type'].compareTo(anotherDoctor['type']));
            if (finalData.length < 1) {
              return Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Doctor found!',
                        style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Image(
                        image: AssetImage('assets/error-404.jpg'),
                        height: 250,
                        width: 250,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: finalData.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doctor = finalData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.blue[50],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 9,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorProfile(
                                doctor: doctor['name'],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(doctor['image']),
                              backgroundColor: Colors.blue,
                              radius: 25,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  doctor['type'],
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Typicons.star_full_outline,
                                      size: 20,
                                      color: Colors.indigo[400],
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      doctor['rating'].toString(),
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
