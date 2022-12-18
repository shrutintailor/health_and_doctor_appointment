import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/diseasedetail.dart';

class Disease extends StatefulWidget {
  const Disease({Key? key}) : super(key: key);

  @override
  State<Disease> createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Disease',
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('disease')
                .orderBy('Name')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.length < 1) {
                return Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Data found!',
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
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black87,
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiseaseDetail(
                              disease: document['Name'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            document['Name'],
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                          Text(
                            document['Symptoms'],
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
