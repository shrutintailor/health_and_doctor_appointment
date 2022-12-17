import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/doctorProfile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SearchList extends StatefulWidget {
  final String searchKey;
  final bool showAppBar;
  const SearchList({Key? key, this.showAppBar = false, required this.searchKey})
      : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    List finalData = [];
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.indigo,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                'Search Result',
                style: GoogleFonts.lato(
                  color: Colors.indigo,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'doctor')
              .orderBy('name')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.active &&
                !snapshot.hasData) {
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
                    .contains(widget.searchKey.toString().toLowerCase())) {
                  finalData.add(snapshot.data!.docs[i]);
                }
              }
            }
            return finalData.isEmpty
                ? Center(
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
                  )
                : Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalData.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doctor = finalData[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Card(
                            color: Colors.blue[50],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 9,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorProfile(
                                        doctor: doctor['name'] ?? 'Not added',
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          doctor['image'],
                                          scale: 1),
                                      //backgroundColor: Colors.blue,
                                      radius: 25,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doctor['name'] ?? 'Not Added',
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          doctor['type'] ?? 'Not added',
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.black54),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                              doctor['rating'] != null
                                                  ? doctor['rating'].toString()
                                                  : 'Not added',
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
                    ),
                  );
          },
        ),
      ),
    );
  }
}
