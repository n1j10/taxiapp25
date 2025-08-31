import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi/driver/Home/Taxi%20requests/type.dart';





class user_requests extends StatelessWidget {
  final String name;

  user_requests(this.name,);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where("الاسم",isEqualTo: name.trim()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ"));
          }
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          var docs = snapshot.data!.docs;

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "طلبات التكسي",
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 12, left: 12),
                    child: Text(
                      "عدد الطلبات : ${docs.length}",
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc = docs[index];

                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 1000 + (index * 100)),
                          tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
                          builder: (context, Offset offset, child) {
                            return Transform.translate(
                              offset: offset * 30,
                              child: Opacity(
                                opacity: 1 - offset.dx,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => My_requeststype(
                                      startLocation: LatLng(
                                        doc['start_location']['lat'],
                                        doc['start_location']['lng'],
                                      ),
                                      endLocation: LatLng(
                                        doc['end_location']['lat'],
                                        doc['end_location']['lng'],
                                      ),
                                      distanceKm: doc['distance_km'],
                                      price: doc['price'],
                                      name: doc['الاسم'],
                                      phone: doc['رقم الهاتف'],
                                      //  timestamp:doc['timestamp'],
                                    ),
                                  ),
                                );


                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) =>
                                //         OrderDetailsPage(
                                //       order: {
                                //         "الاسم": doc["الاسم"],
                                //         "رقم الهاتف": doc["رقم الهاتف"],
                                //         "distance_km": doc["distance_km"],
                                //         "price": doc["price"],
                                //         "start_location": {
                                //           "lat": doc["start_location"]["lat"],
                                //           "lng": doc["start_location"]["lng"],
                                //         },
                                //         "end_location": {
                                //           "lat": doc["end_location"]["lat"],
                                //           "lng": doc["end_location"]["lng"],
                                //         },
                                //         "timestamp": doc["timestamp"],
                                //       },
                                //     ),
                                //   ),
                                // );
                              },

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "الاسم الكامل: ${doc["الاسم"]}",
                                    style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "رقم الهاتف: ${doc["رقم الهاتف"]}",
                                    style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () async {
                                      final FirebaseAuth _auth = FirebaseAuth.instance;

                                      CollectionReference note = FirebaseFirestore.
                                      instance.collection('الطلبات المنجزه');
                                      try {
                                        await note.add({
                                          'start_location': {
                                            doc['start_location']['lat'],
                                            doc['start_location']['lng'],
                                          },
                                          'end_location': {
                                            doc['end_location']['lat'],
                                            doc['end_location']['lng'],
                                          },

                                          "الاسم": "${doc["الاسم"]}",
                                          "رقم الهاتف": "${doc["رقم الهاتف"]}",
                                          "price": "${doc["price"]}",
                                          "distanceKm": "${doc["distance_km"]}",
                                          "اسم السائق": name.trim(),
                                          // "نوع وموديل السيارة": car.trim(),
                                          // "واتساب":was.trim(),

                                        });
                                        FirebaseFirestore.instance.
                                        collection("orders").doc(snapshot.data!.docs[index].id).delete();
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      "موافق على أستلام الطلب",
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}