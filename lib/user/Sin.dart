import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../driver/Home/Home.dart';
import 'Home.dart';

class SignUpuser extends StatefulWidget {
  const SignUpuser({super.key});

  @override
  State<SignUpuser> createState() => _SignUpuserState();
}

class _SignUpuserState extends State<SignUpuser> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول واختيار صورة")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. رفع الصورة إلى Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('الصور/$fileName.jpg');
      await storageRef.putFile(selectedImage!);
      String imageUrl = await storageRef.getDownloadURL();

      // 2. حفظ البيانات إلى Firestore
      await FirebaseFirestore.instance.collection('حسابات الزبائن').add({
        'الاسم': nameController.text.trim(),
        'البريد': emailController.text.trim(),
        'كلمة المرور': passwordController.text,
        'رقم الهاتف': phoneController.text.trim(),
        'صورة': imageUrl,
        'تاريخ الإنشاء': Timestamp.now(),
      });

        try {
          await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          Get.offAll(Homeone( emailController.text.trim()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("خطأ", "كلمة المرور ضعيفة");
          } else if (e.code == 'email-already-in-use') {

          } else {
            Get.snackbar("خطأ", e.message ?? "حدث خطأ");
          }
        }


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
      );


      nameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      setState(() {
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
      );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height*1,
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
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "إنشاء حساب جديد",
                    style: GoogleFonts.cairo(
                      fontSize: 30,
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
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(),
                          decoration: InputDecoration(
                            labelText: "رقم الهاتف",
                            prefixIcon: const Icon(Icons.phone),
                            labelStyle: GoogleFonts.cairo(),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                  selectedImage == null
                                      ? "اختر صورة"
                                      : "تم اختيار صورة",
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