import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi/Visitor/personvistor.dart';



class Visitor extends StatefulWidget {
  const Visitor({super.key});

  @override
  State<Visitor> createState() => _MainPageState();
}

class _MainPageState extends State<Visitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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

  Widget buildTaxiBox() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child:  Center(
            child: Text(
              "اطلب تكسي",
              style: GoogleFonts.cairo(
                textStyle: const TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(onPressed: (){
              Get.to(personvistor());
            },child: Icon(Icons.person),)
          ],
          title:  Text("الصفحة الرئيسية",style: GoogleFonts.cairo(
            textStyle: const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)),
          backgroundColor: Colors.transparent,
        //  elevation: 1,
          foregroundColor: Colors.white,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: InkWell(onTap: (){
                Get.snackbar(
                  "",
                  "",
                  titleText:  Text(
                      "خطأ!!",
                      textDirection: TextDirection.rtl, // ضبط اتجاه النص
                      style: GoogleFonts.cairo(
                        textStyle: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
                  ),
                  messageText:  Text(
                      "عليك تسجيل حساب اولا",
                      textDirection: TextDirection.rtl, // ضبط اتجاه النص
                      style: GoogleFonts.cairo(
                        textStyle: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
                  ),
                  backgroundColor: Colors.white,
                  duration: const Duration(seconds: 1),
                  //  backgroundColor: Colors.black,
                  colorText: Colors.white,
                  padding: const EdgeInsets.all(10),
                  // duration: const Duration(seconds: 3),
                  snackPosition: SnackPosition.TOP, // الإشعار في الأعلى
                  margin: const EdgeInsets.only(left: 100, top: 20, right: 10), // تحريكه لليمين
                  borderRadius: 10, // جعل الزوايا ناعمة
                  isDismissible: true, // السماح بإغلاق الإشعار بالسحب
                  forwardAnimationCurve: Curves.easeOutBack,
                  // snackPosition: SnackPosition.BOTTOM,
                );
              },child: buildTaxiBox()),
            ),
          ),
        ),
      ),
    );
  }
}

