import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class Help extends StatelessWidget {
  const Help({super.key});
  final String instagramUrl = 'https://www.instagram.com/abzx8u?igsh=MWQ2czd2NzI3MXlyMw==';
  PreferredSizeWidget customAppBar(BuildContext context) {
    return
      AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xFF00C6FF),

        centerTitle: true,
        // leading: Builder(
        //   builder: (context) =>
        //       IconButton(
        //         icon: const Icon(Icons.menu, color: Colors.white),
        //         onPressed: () => Scaffold.of(context).openDrawer(),
        //       ),
        // ),
        title: Text(
          "تواصل معنا",
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

  Future<void> _launchUrl(BuildContext context) async {
    final Uri url = Uri.parse(instagramUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء فتح الرابط')),
      );
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: instagramUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ رابط الإنستغرام')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      //  backgroundColor: Colors.grey[100],
        appBar: customAppBar(context),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ZoomIn(
              duration: const Duration(milliseconds: 1600),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      const Text(
                        "إذا واجهت أي مشكلة في التطبيق أو لديك استفسار أو اقتراح، يمكنك التواصل معنا عبر إنستغرام:",
                        style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => _launchUrl(context),
                        child: Pulse(
                          infinite: true,
                          duration: const Duration(seconds: 2),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.indigo.shade50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "asst/p.jpg", // تأكد أن الصورة موجودة في مجلد assets
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton.icon(
                        onPressed: () => _copyLink(context),
                        icon: const Icon(Icons.copy, color: Colors.indigo),
                        label: const Text(
                          "نسخ رابط الإنستغرام",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontFamily: 'Cairo',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "اضغط على الأيقونة أو الرابط أعلاه لزيارة صفحتنا",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 0),
                      const Divider(),
                      const SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

