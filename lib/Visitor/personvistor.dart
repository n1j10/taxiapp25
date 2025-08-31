import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class personvistor extends StatefulWidget {
  const personvistor({super.key});

  @override
  State<personvistor> createState() => _personvistorState();
}

class _personvistorState extends State<personvistor> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: MaterialButton(
              onPressed: (){
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              "الملف الشخصي",
                style: GoogleFonts.cairo(
                  textStyle: const TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),)
            ),
            backgroundColor: Colors.transparent,
            //  elevation: 1,
            foregroundColor: Colors.white,
          ),
          body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        colors: [Color(0xff00c6ff), Color(0xff0072ff)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),child: Column(children: [
      Container(margin: EdgeInsets.only(top: 250),child: Center(
        child: Text("لم تقم باضافة حساب بعد",  style: GoogleFonts.cairo(
          textStyle: const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)),
      ),)
          ],),
          ),
        ));
  }
}
