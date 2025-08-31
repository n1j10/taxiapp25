import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class PersonUser extends StatefulWidget {
  final String name;
  final String phone;
  final String iamg;
  final String typ;
  final String id;

  const PersonUser(this.name, this.phone, this.iamg, this.typ, this.id);

  @override
  State<PersonUser> createState() => _PersonUserState();
}

class _PersonUserState extends State<PersonUser> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late String name;
  late String phone;
  late String img;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phone = widget.phone;
    img = widget.iamg;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: GoogleFonts.cairo(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController phoneController = TextEditingController(text: phone);
    File? newImage;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> pickImage() async {
              final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (picked != null) {
                setStateDialog(() {
                  newImage = File(picked.path);
                });
              }
            }

            Future<void> saveChanges() async {
              setStateDialog(() => isSaving = true);

              String imageUrl = img;

              if (newImage != null) {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('حسابات الزبائن')
                    .child('$phone.jpg');

                await ref.putFile(newImage!);
                imageUrl = await ref.getDownloadURL();
              }

              final query = await FirebaseFirestore.instance
                  .collection('حسابات الزبائن')
                  .where('رقم الهاتف', isEqualTo: widget.phone)
                  .get();

              if (query.docs.isNotEmpty) {
                await query.docs.first.reference.update({
                  'الاسم': nameController.text.trim(),
                  'رقم الهاتف': phoneController.text.trim(),
                  'الصورة': imageUrl,
                });

                Get.back(); // Close dialog
                Get.snackbar("تم التحديث", "تم تعديل البيانات بنجاح");

                // تحديث القيم الظاهرة في الشاشة مباشرة
                setState(() {
                  name = nameController.text.trim();
                  phone = phoneController.text.trim();
                  img = imageUrl;
                });
              } else {
                Get.snackbar("خطأ", "لم يتم العثور على الحساب");
              }

              setStateDialog(() => isSaving = false);
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Center(child: Text("تعديل الحساب", style: GoogleFonts.cairo(fontWeight: FontWeight.bold))),
              content: isSaving
                  ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: newImage != null
                            ? FileImage(newImage!)
                            : NetworkImage(img) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "الاسم",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "رقم الهاتف",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("إلغاء", style: GoogleFonts.cairo()),
                ),
                ElevatedButton(
                  onPressed: saveChanges,
                  child: Text("حفظ", style: GoogleFonts.cairo()),
                ),
              ],
            );
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text("الملف الشخصي",
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff00c6ff), Color(0xff0072ff)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(img),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(name,
                      style: GoogleFonts.cairo(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("📞 $phone",
                      style: GoogleFonts.cairo(
                          color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Text("النوع: ${widget.typ}",
                      style: GoogleFonts.cairo(
                          color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 30),

                  // الأزرار
                  buildButton("تعديل الحساب", Icons.edit, Colors.blue, () {
                    _showEditDialog();
                  }),

                  buildButton("حذف الحساب", Icons.delete_forever, Colors.red, () async {
                    final confirm = await Get.dialog<bool>(
                      AlertDialog(
                        title: Text("تأكيد الحذف", style: GoogleFonts.cairo()),
                        content: Text("هل أنت متأكد أنك تريد حذف الحساب؟", style: GoogleFonts.cairo()),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: Text("إلغاء", style: GoogleFonts.cairo()),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              FirebaseFirestore.instance.collection("حسابات الزبائن").
                              doc(widget.id).delete();
                              Get.back();
                              Get.snackbar("تم", "تم حذف الحسابات",backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  padding: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3));

                            },
                            child: Text("حذف", style: GoogleFonts.cairo()),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    try {
                      // حذف الصورة
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('حسابات الزبائن')
                          .child('$phone.jpg');
                      await ref.delete();

                      // حذف الوثيقة
                      await FirebaseFirestore.instance
                          .collection('حسابات الزبائن')
                          .doc(widget.id)
                          .delete();

                      Get.snackbar("تم الحذف", "تم حذف الحساب بنجاح");
                      Get.back(); // الرجوع للخلف
                    } catch (e) {
                      Get.snackbar("خطأ", "حدث خطأ أثناء حذف الحساب");
                    }
                  }),

                  buildButton("تسجيل الخروج", Icons.logout, Colors.black87, () async{
                    await FirebaseAuth.instance.signOut().then((value) =>   Get.offAll(const WelcomePage()));
                    Get.snackbar("تسجيل الخروج", "تم تسجيل الخروج بنجاح");
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




