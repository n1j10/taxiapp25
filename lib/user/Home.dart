import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:taxi/driver/Home/persondriver.dart';
import 'package:taxi/user/person.dart';

import '../driver/Home/My requests/My requests.dart';
import '../driver/Home/Rne.dart';
import '../driver/Home/Taxi requests/Taxi requests.dart';
import '../driver/Home/laf2.dart';

import 'BaghdadMapPage.dart';
import 'User requests/User requests.dart';





class Homeone extends StatefulWidget {
  final String email;
  Homeone(this.email);

  @override
  _HomeoneState createState() => _HomeoneState();
}

class _HomeoneState extends State<Homeone>  with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    OneSignal.shared.getDeviceState().then((deviceState) {
      print("User IسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسD: ${deviceState?.userId}");
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildTaxiBox(String te) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.1,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                te,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }

  Future<String> checkEmail() async {
    try {
      // 🔹 البحث عن البريد الإلكتروني في المحلات
      var shopQuery = await FirebaseFirestore.instance
          .collection('الحسابات')
          .where("البريد", isEqualTo: widget.email.trim())
          .limit(1)
          .get();

      if (shopQuery.docs.isNotEmpty) {
        return "الحسابات"; // البريد موجود في المحلات
      }

      // 🔹 البحث عن البريد الإلكتروني في المستخدمين
      var userQuery = await FirebaseFirestore.instance
          .collection('حسابات الزبائن')
          .where("البريد", isEqualTo: widget.email.trim())
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        return "حسابات الزبائن"; // البريد موجود في المستخدمين
      }





      return "not_found"; // البريد غير موجود في أي جدول
    } catch (e) {
      print("خطأ: $e");
      return "error";
    }
  }
  as(tw,Ico){
    return

      Text(tw, style: GoogleFonts.cairo(
        textStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13,),
      ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
       // drawer: DrowOne(),
        appBar: AppBar(
          elevation: 0,
          // gradient: LinearGradient(
          //   colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          backgroundColor: Color(0xFF00C6FF),
          title: Text("الصفحة الرئيسية"),
        ),
      

        body: FutureBuilder<String>(
            future: checkEmail(), // ✅ استدعاء الدالة عند فتح الصفحة
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // ⏳ تحميل البيانات
              }

              if (snapshot.hasError || snapshot.data == "error") {
                return const Center(child: Text("❌ حدث خطأ أثناء التحقق!"));
              }

              if (snapshot.data == "حسابات الزبائن") {
                return  Container(
                  child:snapshot.data==ConnectivityResult.none?
                  const Center(child: Text("لايوجد اتصال بالنت قد لا تعمل بعض الوضائف بشكل الصحيح ",style: TextStyle(fontSize: 18),)):
                  FirebaseAuth .instance.currentUser==null?const Center(child: Text("السلة فارغة"),):
                  StreamBuilder(stream:
                  FirebaseFirestore.instance.collection('حسابات الزبائن').where("البريد",isEqualTo:widget.email.trim()).snapshots(),builder:
                      (context,AsyncSnapshot<QuerySnapshot>snapshot){
                    if(snapshot.hasError){
                      //.where("المطعم",isEqualTo:name)
                      return const Text("خطا");
                    }
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const  Center(child: CircularProgressIndicator(color: Colors.white,),);
                    }
                    return
                        Container(
                         // padding: EdgeInsets.all(50),
                          height: MediaQuery.of(context).size.height*1,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child:
                          ListView.builder(itemCount: snapshot.data!.docs.length,
                              itemBuilder:(context,index){
                                return //Text("${snapshot.data!.docs[index]["اسم المنتج"]}");
                                 Container( padding: EdgeInsets.all(15),child: Column(children: [
                                   InkWell(onTap: (){
                                     Get.to(PersonUser(
                                         "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                       "${snapshot.data!.docs[index]["رقم الهاتف"]}".trim(),
                                       "${snapshot.data!.docs[index]["صورة"]}".trim(),
                                       "حساب مستخدم",
                                       snapshot.data!.docs[index].id.trim(),

                                     ));
                                   },child:
                                   buildTaxiBox("الملف الشخصي"),),
                                   SizedBox(height: 30,),
                                   InkWell(
                                       onTap: (){
                                         Get.to(SelectRoutePage(
                                           "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                           "${snapshot.data!.docs[index]["رقم الهاتف"]}".trim(),
                                         ));
                                       },
                                       child: Container(child: buildTaxiBox("اطلب تكسي"),)),
                                   SizedBox(height: 30,),
                                   InkWell(
                                       onTap: (){
                                         print("${snapshot.data!.docs[index]["الاسم"]}".trim(),);
                                         Get.to(user_requests(
                                           "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                         ));
                                       },
                                       child: Container(child: buildTaxiBox("طلباتي"),)),
                                   SizedBox(height: 30,),
                                   InkWell(
                                       onTap: (){
                                         print("${snapshot.data!.docs[index]["الاسم"]}".trim(),);
                                         Get.to(Help(

                                         ));
                                       },
                                       child: Container(child: buildTaxiBox("تواصل معنا"),)),
                                   SizedBox(height: 30,),
                                   InkWell(
                                       onTap: (){

                                         Get.to(Rne(

                                         ));
                                       },
                                       child: Container(child: buildTaxiBox("من نحن"),))

                                 ],),);




                              }),
                        );



                  },),


                );


              }
              if (snapshot.data == "الحسابات") {
                return  Container(
                  child:snapshot.data==ConnectivityResult.none?
                  const Center(child: Text("لايوجد اتصال بالنت قد لا تعمل بعض الوضائف بشكل الصحيح ",style: TextStyle(fontSize: 18),)):
                  FirebaseAuth .instance.currentUser==null?const Center(child: Text("السلة فارغة"),):
                  StreamBuilder(stream:
                  FirebaseFirestore.instance.collection('الحسابات').where("البريد",isEqualTo:widget.email.trim()).snapshots(),builder:
                      (context,AsyncSnapshot<QuerySnapshot>snapshot){
                    if(snapshot.hasError){
                      //.where("المطعم",isEqualTo:name)
                      return const Text("خطا");
                    }
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const  Center(child: CircularProgressIndicator(color: Colors.white,),);
                    }
                    return
                      Container(
                        padding: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height*1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:
                        ListView.builder(itemCount: snapshot.data!.docs.length,
                            itemBuilder:(context,index){
                              return //Text("${snapshot.data!.docs[index]["اسم المنتج"]}");
                                Container(child: Column(children: [
                                  InkWell(onTap: (){
                                    Get.to(Persondriver(
                                      "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                      "${snapshot.data!.docs[index]["رقم الهاتف"]}".trim(),
                                      "${snapshot.data!.docs[index]["الصورة"]}".trim(),
                                      "${snapshot.data!.docs[index]["واتساب"]}".trim(),
                                      "${snapshot.data!.docs[index]["نوع وموديل السيارة"]}".trim(),
                                      "حساب سائق",
                                      snapshot.data!.docs[index].id.trim(),

                                    ));


                                  },child:
                                  buildTaxiBox("الملف الشخصي"),),
                                  SizedBox(height: 30,),
                                  InkWell(
                                      onTap: (){
                                        Get.to(Taxi_requests(
                                            "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                            "${snapshot.data!.docs[index]["رقم الهاتف"]}".trim(),
                                            "${snapshot.data!.docs[index]["نوع وموديل السيارة"]}".trim(),
                                            snapshot.data!.docs[index].id

                                        ));
                                      },
                                      child: Container(child: buildTaxiBox("طلبات التكسي"),)),
                                  SizedBox(height: 30,),
                                  InkWell(
                                      onTap: (){
                                        print("${snapshot.data!.docs[index]["الاسم"]}".trim(),);
                                        Get.to(My_requests(
                                          "${snapshot.data!.docs[index]["الاسم"]}".trim(),
                                        ));
                                      },
                                      child: Container(child: buildTaxiBox("طلباتي"),)),
                                  SizedBox(height: 30,),
                                  InkWell(
                                      onTap: (){
                                        print("${snapshot.data!.docs[index]["الاسم"]}".trim(),);
                                        Get.to(Help(

                                        ));
                                      },
                                      child: Container(child: buildTaxiBox("تواصل معنا"),)),
                                  SizedBox(height: 30,),
                                  InkWell(
                                      onTap: (){

                                        Get.to(Rne(

                                        ));
                                      },
                                      child: Container(child: buildTaxiBox("من نحن"),))

                                ],),);




                            }),
                      );



                  },),


                );


              }

              return  Column(children: [
                SizedBox(height: 200,),
                Center(child:
                Text("هذا الحساب شخصي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))),

                MaterialButton(child:  Center(
                  child: Text("تسجيل خروج",
                    style: GoogleFonts.cairo(
                      textStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),),
                ),onPressed: (){
                  FirebaseAuth.instance.signOut();
                  //Get.offAll( OneHome());
                }, ),
              ],);
            }



        ),
      ),
    );
  }
}