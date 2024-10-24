import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/models/get_product.dart';
import 'package:fontend_miniproject2/models/follow_product.dart';

class FollowProductPage extends StatefulWidget {
  final String track;
  final int uid;
  FollowProductPage({super.key, required this.track, required this.uid});

  @override
  State<FollowProductPage> createState() => _FollowProductPageState();
}

class _FollowProductPageState extends State<FollowProductPage> {
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();
  List<Marker> markers = []; // รายการ marker
  List<FollowProduct> getp = [];

  @override
  void initState() {
    super.initState();
    loadDataProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ติดตามพัสดุ',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: latLng,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            maxNativeZoom: 19,
          ),
          MarkerLayer(
            markers: markers, // markers ที่ถูกอัพเดตเมื่อข้อมูลโหลดเสร็จ
          ),
        ],
      ),
    );
  }

  Future<void> loadDataProduct() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response =
        await http.get(Uri.parse("$url/product/sender/${widget.uid}"));
    if (response.statusCode == 200) {
      getp = followProductFromJson(response.body);
      log(response.body);

      // ลูปเพื่อตรวจสอบแต่ละตำแหน่งของผู้รับ
      for (var product in getp) {
        if (product.receiverLatitude != null &&
            product.receiverLongitude != null) {
          try {
            double latitude = double.parse(product.receiverLatitude!);
            double longitude = double.parse(product.receiverLongitude!);

            // สร้าง marker สำหรับผู้รับ
            final receiverMarker = Marker(
              point: LatLng(latitude, longitude),
              width: 50,
              height: 50,
              child: Image.asset(
                'assets/images/maker.png',
                width: 50,
                height: 50,
              ),
            );

            // อัพเดต markers
            setState(() {
              markers.add(receiverMarker);
            });

            // ย้ายไปที่ตำแหน่งของผู้รับ (สามารถใช้แค่ตำแหน่งแรกถ้าต้องการ)
            mapController.move(LatLng(latitude, longitude), 15.0);
          } catch (e) {
            log('Error parsing receiver latitude or longitude: $e');
          }
        }
      }

      rideraddress();
    } else {
      log('Error loading product data: ${response.statusCode}');
    }
  }

  Future<void> rideraddress() async {
    CollectionReference inboxCollection =
        FirebaseFirestore.instance.collection('inbox2');

    try {
      // ดึงข้อมูลทั้งหมดในคอลเลกชัน inbox2
      QuerySnapshot querySnapshot = await inboxCollection.get();

      // ตรวจสอบข้อมูลทั้งหมดใน getp
      for (var ridFk in getp.map((e) => e.ridFk.toString())) {
        // ตรวจสอบเอกสารในคอลเลกชัน
        for (var doc in querySnapshot.docs) {
          // ตรวจสอบว่า documentId ตรงกับ getp.ridFk หรือไม่
          if (doc.id == ridFk) {
            var data = doc.data() as Map<String, dynamic>;
            log('Document data: ${data}');

            // ตรวจสอบว่ามีค่า lat และ lng หรือไม่
            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              try {
                double latitude = data['latitude'];
                double longitude = data['longitude'];

                // สร้าง marker สำหรับไรเดอร์
                final riderMarker = Marker(
                  point: LatLng(latitude, longitude),
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    'assets/images/rider.png',
                    width: 70,
                    height: 70,
                  ),
                );

                // อัพเดต markers
                setState(() {
                  markers.add(riderMarker);
                });
              } catch (e) {
                log('Error parsing rider latitude or longitude: $e');
              }
            } else {
              log('Latitude or longitude not found in document');
            }

            // เมื่อพบ document ที่ต้องการแล้วให้หยุดการวนลูป
            break;
          }
        }
      }
    } catch (e) {
      log('Error fetching documents: $e');
    }

    // รีเฟรช UI เพื่อให้แสดง marker ทั้งหมด
    setState(() {});
  }
}
