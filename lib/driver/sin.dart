// import 'dart:io';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
//
//
// class Sindriver extends StatefulWidget {
//   const Sindriver({super.key});
//
//   @override
//   State<Sindriver> createState() => _SindriverState();
// }
//
// class _SindriverState extends State<Sindriver> with SingleTickerProviderStateMixin {
//
//
//   String playerId = '';
//
//   get_id_manger() async {
//     await FirebaseFirestore.instance.collection('id_manger').get().then((
//         value) {
//       setState(() {
//         playerId = value.docs[0]['id'];
//       });
//     });
//   }
//
//   Future<void> sendNotificationToAllUsers(String title, String content) async {
//     const String oneSignalAppId = "90aa34d8-1168-4157-aac3-b9c1c4055e39";
//     const String restApiKey = "n5hidzgemec2mqmqcq2ibvoyn";
//
//     final url = Uri.parse('https://onesignal.com/api/v1/notifications');
//     final headers = {
//       "Content-Type": "application/json; charset=UTF-8",
//       "Authorization": "Basic $restApiKey"
//     };
//     final body = jsonEncode({
//       "app_id": oneSignalAppId,
//       "include_player_ids": [playerId],
//       "headings": {"en": title},
//       "contents": {"en": content},
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       print("Notification sent successfully.");
//     } else {
//       print("Failed to send notification: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     }
//   }
//
//
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController carController = TextEditingController();
//   final TextEditingController wasController = TextEditingController();
//
//
//
//   File? selectedImage;
//   bool isLoading = false;
//
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     get_id_manger();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 5000),
//       vsync: this,
//     );
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
//     _controller.forward();
//   }
//
//   Future<void> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> saveToFirestore() async {
//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         wasController.text.isEmpty ||
//         carController.text.isEmpty ||
//         selectedImage == null) {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         const SnackBar(content: Text("يرجى تعبئة جميع الحقول واختيار صورة")),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // 1. رفع الصورة إلى Firebase Storage
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final storageRef = FirebaseStorage.instance.ref().child('الصور/$fileName.jpg');
//       await storageRef.putFile(selectedImage!);
//       String imageUrl = await storageRef.getDownloadURL();
//
//       // 2. حفظ البيانات إلى Firestore
//       await FirebaseFirestore.instance.collection('طلبات السواق').add({
//         'الاسم': nameController.text.trim(),
//         'البريد': emailController.text.trim(),
//         'كلمة المرور': passwordController.text,
//         'رقم الهاتف': phoneController.text.trim(),
//         "نوع السيارة":carController.text.trim(),
//         "واتساب":wasController.text.trim(),
//         'صورة': imageUrl,
//         'تاريخ الإنشاء': Timestamp.now(),
//       });
//
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
//       );
//
//       nameController.clear();
//       emailController.clear();
//       passwordController.clear();
//       phoneController.clear();
//       carController.clear();
//       wasController.clear();
//       setState(() {
//         selectedImage = null;
//       });
//     } catch (e) {
//
//         SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e"));
//
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     carController.dispose();
//     wasController.dispose();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: Container(
//           height: MediaQuery.of(context).size.height*1,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SlideTransition(
//             position: _animation,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   Text(
//                     "قم بانشاء حسابك كسائق للانظمام معنا واستلام الطلبات",
//                     style: GoogleFonts.cairo(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//
//
//                         TextField(
//                           controller: emailController,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "البريد الإلكتروني",
//                             prefixIcon: const Icon(Icons.email),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "كلمة المرور",
//                             prefixIcon: const Icon(Icons.lock),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: nameController,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "الاسم الكامل",
//                             prefixIcon: const Icon(Icons.person),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "رقم الهاتف",
//                             prefixIcon: const Icon(Icons.phone),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextField(
//                           controller: wasController,
//                           keyboardType: TextInputType.phone,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "واتساب للتواصل",
//                             prefixIcon: const Icon(Icons.phone_bluetooth_speaker),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//
//                         const SizedBox(height: 20),
//
//                         TextField(
//                           controller: carController,
//                          // keyboardType: TextInputType.phone,
//                           style: GoogleFonts.cairo(),
//                           decoration: InputDecoration(
//                             labelText: "نوع وموديل السيارة",
//                             prefixIcon: const Icon(Icons.car_crash),
//                             labelStyle: GoogleFonts.cairo(),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         GestureDetector(
//                           onTap: pickImage,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.image),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   selectedImage == null
//                                       ? "اختر صورة"
//                                       : "تم اختيار صورة",
//                                   style: GoogleFonts.cairo(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         isLoading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                           onPressed:(){
//                             saveToFirestore();
//
//                             sendNotificationToAllUsers("طلب جديد","هنالك طلب تسجيل جديد");
//                           } ,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0072FF),
//                             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: Text(
//                             "إنشاء الحساب",
//                             style: GoogleFonts.cairo(fontSize: 18, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../user/Home.dart';

class Sindriver extends StatefulWidget {
  const Sindriver({super.key});

  @override
  State<Sindriver> createState() => _SindriverState();
}

class _SindriverState extends State<Sindriver> with SingleTickerProviderStateMixin {

  String playerId = '';

  get_id_manger() async {
    await FirebaseFirestore.instance.collection('id').get().then((value) {
      setState(() {
        playerId = value.docs[0]['phone'];
        print("Player ID: $playerId");
      });
    });
  }


  Future<void> sendNotificationToAllUsers(String title, String content) async {
    if (playerId.isEmpty) {
      print("🚫 لا يوجد playerId صالح.");
      return;
    }

    const String oneSignalAppId = "90aa34d8-1168-4157-aac3-b9c1c4055e39";
    const String restApiKey =
        "os_v2_app_scvdjwarnbavpkwdxha4ibk6hhru66pd6ifeannlj6dctcps7gndoh6y45zb5mkt5tqesanp7wriyfvz6tj5bzqw2c6zysyb57varky";

    final url = Uri.parse('https://onesignal.com/api/v1/notifications');
    final headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Basic $restApiKey",
    };

    final body = jsonEncode({
      "app_id": oneSignalAppId,
      "included_segments": ["All"],
      "contents": {
        "en": content, // تأكد أن المحتوى باللغة الإنجليزية موجود دائمًا
        "ar": "📢 $content" // يمكنك تخصيص النص العربي أيضاً
      },
      "headings": {
        "en": title,
        "ar": "📢 $title"
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("✅ تم إرسال الإشعار بنجاح.");
    } else {
      print("❌ فشل في إرسال الإشعار");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carController = TextEditingController();
  final TextEditingController wasController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    get_id_manger();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveToFirestore() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        wasController.text.isEmpty ||
        carController.text.isEmpty ||
        selectedImage == null) {

        const SnackBar(content: Text("يرجى تعبئة جميع الحقول واختيار صورة"));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('الصور/$fileName.jpg');
      await storageRef.putFile(selectedImage!);
      String imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('الحسابات').add({
        'الاسم': nameController.text.trim(),
        'البريد': emailController.text.trim(),
        'كلمة السر': passwordController.text,
        'رقم الهاتف': phoneController.text.trim(),
        "نوع وموديل السيارة": carController.text.trim(),
        "واتساب": wasController.text.trim(),
        'الصورة': imageUrl,
        'تاريخ الإنشاء': Timestamp.now(),
      });

      _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password:passwordController.text.trim(),
      );


        const SnackBar(content: Text("تم إنشاء الحساب بنجاح"));
     //   Get.offAll(Homeone( emailController.text.trim()));


      nameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      carController.clear();
      wasController.clear();
      setState(() {
        selectedImage = null;
      });

      // ✅ إرسال الإشعار بعد الحفظ
      await sendNotificationToAllUsers("طلب جديد", "هنالك طلب تسجيل جديد");

    } catch (e) {

        SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e"));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    carController.dispose();
    wasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SlideTransition(
            position: _animation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "قم بانشاء حسابك كسائق للانظمام معنا واستلام الطلبات",
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "البريد الإلكتروني",
                            prefixIcon: const Icon(Icons.email),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "كلمة المرور",
                            prefixIcon: const Icon(Icons.lock),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: nameController,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "الاسم الكامل",
                            prefixIcon: const Icon(Icons.person),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "رقم الهاتف",
                            prefixIcon: const Icon(Icons.phone),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: wasController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "واتساب للتواصل",
                            prefixIcon: const Icon(Icons.phone_bluetooth_speaker),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: carController,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "نوع وموديل السيارة",
                            prefixIcon: const Icon(Icons.car_crash),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            child: Row(
                              children: [
                                const Icon(Icons.image),
                                const SizedBox(width: 10),
                                Text(
                                  selectedImage == null ? "اختر صورة" : "تم اختيار صورة",
                                  style: GoogleFonts.cairo(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: saveToFirestore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0072FF),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "إنشاء الحساب",
                            style: GoogleFonts.cairo(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
