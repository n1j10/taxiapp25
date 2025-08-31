import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi/driver/Home/My%20requests/type.dart';
import '../Taxi requests/type.dart';


class My_requests extends StatelessWidget {
  String name ; //
  My_requests(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('الطلبات المنجزه').where("اسم السائق",isEqualTo: name.trim()).snapshots(),
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
                      "طلبات الخاصة",
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  Container(
                   // height: 50,
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
                            margin: const EdgeInsets.all(7),
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
                                    builder: (_) => ShowBaghdadMapPage(
                                      startLocation: LatLng(
                                        doc['start_location'][0], // Latitude
                                        doc['start_location'][1], // Longitude
                                      ),
                                      endLocation: LatLng(
                                        doc['end_location'][0],
                                        doc['end_location'][1],
                                      ),
                                      distanceKm: doc['distanceKm'].toString(), // لأنه String أساسًا
                                      price: int.parse(doc['price'].toString()), // تحويل من String إلى int
                                      name: doc['الاسم'],
                                      phone: doc['رقم الهاتف'],
                                      //  timestamp:doc['timestamp'],
                                    ),
                                  ),
                                );



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