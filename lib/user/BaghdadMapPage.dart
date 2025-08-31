



// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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
// class SelectRoutePage extends StatefulWidget {
//   final String name;
//   final String phone;
//   const SelectRoutePage(this.name,this.phone);
//
//   @override
//   State<SelectRoutePage> createState() => _SelectRoutePageState();
// }
//
// class _SelectRoutePageState extends State<SelectRoutePage> {
//
//   String playerId = '';
//
//   get_id_manger() async {
//     await FirebaseFirestore.instance.collection('id').get().then((value) {
//       setState(() {
//         playerId = value.docs[0]['phone'];
//         print("Player ID: $playerId");
//       });
//     });
//   }
//
//
//   Future<void> sendNotificationToAllUsers(String title, String content) async {
//     if (playerId.isEmpty) {
//       print("🚫 لا يوجد playerId صالح.");
//       return;
//     }
//
//     const String oneSignalAppId = "90aa34d8-1168-4157-aac3-b9c1c4055e39";
//     const String restApiKey =
//         "os_v2_app_scvdjwarnbavpkwdxha4ibk6hhru66pd6ifeannlj6dctcps7gndoh6y45zb5mkt5tqesanp7wriyfvz6tj5bzqw2c6zysyb57varky";
//
//     final url = Uri.parse('https://onesignal.com/api/v1/notifications');
//     final headers = {
//       "Content-Type": "application/json; charset=UTF-8",
//       "Authorization": "Basic $restApiKey",
//     };
//
//     final body = jsonEncode({
//       "app_id": oneSignalAppId,
//       "included_segments": ["All"],
//       "contents": {
//         "en": content, // تأكد أن المحتوى باللغة الإنجليزية موجود دائمًا
//         "ar": "📢 $content" // يمكنك تخصيص النص العربي أيضاً
//       },
//       "headings": {
//         "en": title,
//         "ar": "📢 $title"
//       }
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       print("✅ تم إرسال الإشعار بنجاح.");
//     } else {
//       print("❌ فشل في إرسال الإشعار");
//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     }
//   }
//
//
//   String playerId1='';
//   get_id_manger1()async{
//     await FirebaseFirestore.instance.collection("الحسابات").get().then((value) {
//       setState(() {
//         playerId1=value.docs[0]['phone'];
//       });
//     });
//     print(playerId1);
//     print('playerId');
//     // print(widget.eami.trim().length);
//     // print(widget.eami.trim().length);
//   }
//
//   Future<void> sendNotificationToAllUsers1(String title, String content) async {
//     if (playerId1.isEmpty) {
//       print("🚫 لا يوجد playerId صالح.");
//       return;
//     }
//
//     const String oneSignalAppId = "90aa34d8-1168-4157-aac3-b9c1c4055e39";
//     const String restApiKey =
//         "os_v2_app_scvdjwarnbavpkwdxha4ibk6hhru66pd6ifeannlj6dctcps7gndoh6y45zb5mkt5tqesanp7wriyfvz6tj5bzqw2c6zysyb57varky";
//
//     final url = Uri.parse('https://onesignal.com/api/v1/notifications');
//     final headers = {
//       "Content-Type": "application/json; charset=UTF-8",
//       "Authorization": "Basic $restApiKey",
//     };
//
//     final body = jsonEncode({
//       "app_id": oneSignalAppId,
//       "included_segments": ["All"],
//       "contents": {
//         "en": content, // تأكد أن المحتوى باللغة الإنجليزية موجود دائمًا
//         "ar": "📢 $content" // يمكنك تخصيص النص العربي أيضاً
//       },
//       "headings": {
//         "en": title,
//         "ar": "📢 $title"
//       }
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       print("✅ تم إرسال الإشعار بنجاح.");
//     } else {
//       print("❌ فشل في إرسال الإشعار");
//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     }
//   }
//
//
//   LatLng? _startPoint;
//   LatLng? _endPoint;
//
//   final Distance _distance = Distance();
//
//   Future<void> _submitOrder(double distance, int price) async {
//     if (_startPoint != null && _endPoint != null) {
//       await FirebaseFirestore.instance.collection('orders').add({
//         'start_location': {
//           'lat': _startPoint!.latitude,
//           'lng': _startPoint!.longitude,
//         },
//         'end_location': {
//           'lat': _endPoint!.latitude,
//           'lng': _endPoint!.longitude,
//         },
//         'distance_km': distance.toStringAsFixed(2),
//         'price': price,
//         "الاسم":widget.name.trim(),
//         "رقم الهاتف":widget.phone.trim(),
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//         const SnackBar(content: Text('تم إرسال الطلب بنجاح!'));
//
//       setState(() {
//         _startPoint = null;
//         _endPoint = null;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     get_id_manger();
//     get_id_manger1();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double? distanceInKm;
//     int? price;
//     if (_startPoint != null && _endPoint != null) {
//       distanceInKm = _distance.as(
//         LengthUnit.Kilometer,
//         _startPoint!,
//         _endPoint!,
//       );
//       price = (distanceInKm * 500).round();
//     }
//
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('اختر نقطة انطلاق ووصول'),
//           backgroundColor: Colors.teal,
//         ),
//         body: Stack(
//           children: [
//             FlutterMap(
//               options: MapOptions(
//                 center: LatLng(33.3152, 44.3661),
//                 zoom: 12.0,
//                 onTap: (tapPosition, point) {
//                   setState(() {
//                     if (_startPoint == null) {
//                       _startPoint = point;
//                     } else if (_endPoint == null) {
//                       _endPoint = point;
//                     } else {
//                       _startPoint = point;
//                       _endPoint = null;
//                     }
//                   });
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: const ['a', 'b', 'c'],
//                   userAgentPackageName: 'com.example.taxiapp',
//                 ),
//                 if (_startPoint != null || _endPoint != null)
//                   MarkerLayer(
//                     markers: [
//                       if (_startPoint != null)
//                         Marker(
//                           point: _startPoint!,
//                           width: 40,
//                           height: 40,
//                           builder: (context) => const Icon(
//                             Icons.location_on,
//                             color: Colors.green,
//                             size: 40,
//                           ),
//                         ),
//                       if (_endPoint != null)
//                         Marker(
//                           point: _endPoint!,
//                           width: 40,
//                           height: 40,
//                           builder: (context) => const Icon(
//                             Icons.location_on,
//                             color: Colors.red,
//                             size: 40,
//                           ),
//                         ),
//                     ],
//                   ),
//                 if (_startPoint != null && _endPoint != null)
//                   PolylineLayer(
//                     polylines: [
//                       Polyline(
//                         points: [_startPoint!, _endPoint!],
//                         strokeWidth: 4.0,
//                         color: Colors.blue,
//                       )
//                     ],
//                   ),
//               ],
//             ),
//             if (_startPoint == null || _endPoint == null)
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 right: 16,
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Text(
//                     'اضغط على الخريطة لاختيار نقطة الانطلاق ثم نقطة الوصول.',
//                     style: TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         bottomNavigationBar: distanceInKm != null && price != null
//             ? Container(
//           padding: const EdgeInsets.all(16),
//           color: Colors.teal[50],
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'المسافة: ${distanceInKm.toStringAsFixed(2)} كم',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'سعر الرحلة: $price دينار',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: (){
//                   _submitOrder(distanceInKm!, price!);
//                   sendNotificationToAllUsers('طلب تكسي',"طلب تكسي جديد");
//                   sendNotificationToAllUsers1('طلب تكسي',"طلب تكسي جديد");
//                 },
//               //  onPressed: () => _submitOrder(distanceInKm!, price!),
//                 icon: const Icon(Icons.check),
//                 label: const Text('إتمام الطلب'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               )
//             ],
//           ),
//         )
//             : null,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _startPoint = null;
//               _endPoint = null;
//             });
//           },
//           backgroundColor: Colors.teal,
//           child: const Icon(Icons.refresh),
//           tooltip: 'إعادة التعيين',
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

class SelectRoutePage extends StatefulWidget {
  final String name;
  final String phone;
  const SelectRoutePage(this.name, this.phone);

  @override
  State<SelectRoutePage> createState() => _SelectRoutePageState();
}

class _SelectRoutePageState extends State<SelectRoutePage> {
  LatLng? _startPoint;
  LatLng? _endPoint;

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final Distance _distance = Distance();

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress("بغداد $address");
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      print("❌ خطأ في تحديد الموقع: $e");
    }
    return null;
  }

  Future<void> sendNotification(String title, String content) async {
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
        "en": content,
        "ar": "📢 $content"
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

  Future<void> _submitOrder(double distance, int price) async {
    if (_startPoint != null && _endPoint != null) {
      await FirebaseFirestore.instance.collection('orders').add({
        'start_location': {
          'lat': _startPoint!.latitude,
          'lng': _startPoint!.longitude,
        },
        'end_location': {
          'lat': _endPoint!.latitude,
          'lng': _endPoint!.longitude,
        },
        'distance_km': distance.toStringAsFixed(2),
        'price': price,
        "الاسم": widget.name.trim(),
        "رقم الهاتف": widget.phone.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الطلب بنجاح!')),
      );

      setState(() {
        _startPoint = null;
        _endPoint = null;
        _startController.clear();
        _endController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? distanceInKm;
    int? price;
    if (_startPoint != null && _endPoint != null) {
      distanceInKm = _distance.as(
        LengthUnit.Kilometer,
        _startPoint!,
        _endPoint!,
      );
      price = (distanceInKm * 500).round();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر نقطة انطلاق ووصول'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: TextField(
                controller: _startController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن نقطة الانطلاق...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final point = await _getCoordinatesFromAddress(_startController.text);
                      if (point != null) {
                        setState(() {
                          _startPoint = point;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لم يتم العثور على الموقع')),
                        );
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: TextField(
                controller: _endController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن نقطة الوصول...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final point = await _getCoordinatesFromAddress(_endController.text);
                      if (point != null) {
                        setState(() {
                          _endPoint = point;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لم يتم العثور على الموقع')),
                        );
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: LatLng(33.3152, 44.3661),
                      zoom: 12.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          if (_startPoint == null) {
                            _startPoint = point;
                          } else if (_endPoint == null) {
                            _endPoint = point;
                          } else {
                            _startPoint = point;
                            _endPoint = null;
                          }
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.taxiapp',
                      ),
                      if (_startPoint != null || _endPoint != null)
                        MarkerLayer(
                          markers: [
                            if (_startPoint != null)
                              Marker(
                                point: _startPoint!,
                                width: 40,
                                height: 40,
                                builder: (context) => const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                            if (_endPoint != null)
                              Marker(
                                point: _endPoint!,
                                width: 40,
                                height: 40,
                                builder: (context) => const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                          ],
                        ),
                      if (_startPoint != null && _endPoint != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [_startPoint!, _endPoint!],
                              strokeWidth: 4.0,
                              color: Colors.blue,
                            )
                          ],
                        ),
                    ],
                  ),
                  if (_startPoint == null || _endPoint == null)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'اضغط على الخريطة لاختيار نقطة الانطلاق ثم نقطة الوصول.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: distanceInKm != null && price != null
            ? Container(
          padding: const EdgeInsets.all(16),
          color: Colors.teal[50],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المسافة: ${distanceInKm.toStringAsFixed(2)} كم',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'سعر الرحلة: $price دينار',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  _submitOrder(distanceInKm!, price!);
                  sendNotification('طلب تكسي', "طلب تكسي جديد");
                },
                icon: const Icon(Icons.check),
                label: const Text('إتمام الطلب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        )
            : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _startPoint = null;
              _endPoint = null;
              _startController.clear();
              _endController.clear();
            });
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.refresh),
          tooltip: 'إعادة التعيين',
        ),
      ),
    );
  }
}
