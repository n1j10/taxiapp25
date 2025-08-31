import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Rne extends StatefulWidget {
  const Rne({super.key});

  @override
  State<Rne> createState() => _RneState();
}

class _RneState extends State<Rne> with SingleTickerProviderStateMixin {
  PreferredSizeWidget customAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "عن تطبيق تكسي ",
        style: GoogleFonts.cairo(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildSection(String title, String content) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.6,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: customAppBar(context),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildSection("عن التطبيق",
                "تطبيق \"تكسي\" هو منصة سهلة وسريعة لطلب سيارات الأجرة داخل محافظة بغداد فقط. يوفر التطبيق خدمات آمنة وموثوقة مع واجهة مستخدم بسيطة."),

            buildSection("هدفنا",
                "نسعى لتوفير تجربة نقل مميزة داخل بغداد من خلال ربط الركاب بسائقين موثوقين بسرعة وسهولة مع ضمان السلامة والراحة."),

            buildSection("الخصوصية والأمان",
                "نحرص على حماية بيانات المستخدمين باستخدام أحدث تقنيات التشفير، ولا نشارك أي معلومات مع جهات خارجية."),

            buildSection("المزايا",
                "✓ طلب تكسي داخل بغداد فقط\n"
                    "✓ تتبع مباشر لموقع السيارة\n"
                    "✓ إشعارات فورية لحالة الرحلة\n"
                    "✓ دعم كامل للغة العربية\n"
                    "✓ تصميم بسيط وسهل الاستخدام"),
          ],
        ),
      ),
    );
  }
}



