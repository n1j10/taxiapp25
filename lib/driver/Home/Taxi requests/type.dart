

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class My_requeststype extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final String distanceKm;
  final int price;
  final String name;
  final String phone;
 // final DateTime timestamp;

  const My_requeststype({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.distanceKm,
    required this.price,
    required this.name,
    required this.phone,
    // required this.timestamp,
  });

  @override
  State<My_requeststype> createState() => _My_requeststypeState();
}

class _My_requeststypeState extends State<My_requeststype> {
  String startAddress = '';
  String endAddress = '';

  @override
  void initState() {
    super.initState();
    getAddresses();
  }

  Future<void> getAddresses() async {
    try {
      List<Placemark> startPlacemarks = await placemarkFromCoordinates(
        widget.startLocation.latitude,
        widget.startLocation.longitude,
        localeIdentifier: "ar",
      );

      List<Placemark> endPlacemarks = await placemarkFromCoordinates(
        widget.endLocation.latitude,
        widget.endLocation.longitude,
        localeIdentifier: "ar",
      );

      setState(() {
        startAddress = "${startPlacemarks.first.locality ?? ''} - ${startPlacemarks.first.street ?? ''}";
        endAddress = "${endPlacemarks.first.locality ?? ''} - ${endPlacemarks.first.street ?? ''}";
      });
    } catch (e) {
      setState(() {
        startAddress = "غير متوفرة";
        endAddress = "غير متوفرة";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  //  final formattedDate = DateFormat('yyyy/MM/dd – hh:mm a', 'ar').format(widget.timestamp);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Column(
        children: [
          // بيانات الطلب
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الاسم: ${widget.name}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("رقم الهاتف: ${widget.phone}", style: const TextStyle(fontSize: 16)),
                Text("المسافة: ${widget.distanceKm} كم", style: const TextStyle(fontSize: 16)),
                Text("السعر: ${widget.price} دينار", style: const TextStyle(fontSize: 16)),
              //  Text("تاريخ الطلب: $formattedDate", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text("من: $startAddress", style: const TextStyle(fontSize: 16, color: Colors.blue)),
                Text("إلى: $endAddress", style: const TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          ),
          // الخريطة
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: widget.startLocation,
                zoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.testapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.startLocation,
                      builder: (ctx) => const Icon(Icons.location_on, color: Colors.red, size: 40),
                      width: 40,
                      height: 40,
                    ),
                    Marker(
                      point: widget.endLocation,
                      builder: (ctx) => const Icon(Icons.flag, color: Colors.green, size: 40),
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [widget.startLocation, widget.endLocation],
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}













