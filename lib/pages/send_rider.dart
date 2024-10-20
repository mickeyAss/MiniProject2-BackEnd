import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/home_user.dart';
import 'package:fontend_miniproject2/models/get_user2.dart';
import 'package:fontend_miniproject2/pages/final_rider.dart';
import 'package:fontend_miniproject2/models/get_product.dart';
import 'package:fontend_miniproject2/models/get_data_rider.dart';
import 'package:fontend_miniproject2/pages/parcel_receiced_rider.dart';

class SendRederPage extends StatefulWidget {
  int rid = 0;
  String trackingNumber = '';
  SendRederPage({super.key, required this.rid, required this.trackingNumber});

  @override
  State<SendRederPage> createState() => _SendRederPageState();
}

class _SendRederPageState extends State<SendRederPage> {
  LatLng? latLng; // ตำแหน่งปัจจุบัน
  List<Marker> markers = []; // รายการ marker

  MapController mapController = MapController();
  late GetProduct getp;
  late GetDataRider getrider;
  var db = FirebaseFirestore.instance;
  late Future<void> loadData;
  late Future<void> loadData_Rider;
  late StreamSubscription listener;

  bool isLoading = true;

  @override
  void dispose() {
    listener.cancel(); // ปิดการฟังเมื่อไม่ใช้งาน
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation(); // เรียกฟังก์ชันที่ใช้ async
    loadData = loadDataProduct(); // โหลดข้อมูลสินค้า
    loadData_Rider = loadDataRider();

    // ติดตามเอกสารใน Firestore
    final docRef = db.collection("inbox2").doc("Doc1");
    listener = docRef.snapshots().listen(
      (event) {
        var data = event.data();
        if (data != null) {
          latLng = LatLng(data['latitude'], data['longitude']); // อัปเดตตำแหน่ง
          setState(() {}); // รีเรนเดอร์เมื่อได้ข้อมูลใหม่
          log("current data: ${event.data()}");
        }
      },
      onError: (error) => log("Listen failed: $error"),
    );

    // ติดตามการเปลี่ยนแปลงตำแหน่ง
    _startListeningPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: latLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                isLoading
                    ? CircularProgressIndicator() // แสดงการโหลด
                    : FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: latLng!,
                          initialZoom: 15.0,
                          onMapReady: () {
                            mapController.move(latLng!, 15.0);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                            maxNativeZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              // Marker สำหรับตำแหน่งปัจจุบัน
                              Marker(
                                point: latLng!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.navigation,
                                  size: 30,
                                  color: Color.fromARGB(255, 0, 26, 128),
                                ),
                              ),
                              ...markers, // เพิ่ม marker ที่มาจาก API
                            ],
                          ),
                          // ปุ่มที่อยู่ติดขอบล่าง
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, -4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: getp.proStatus == 'รอไรเดอร์มารับ'
                                  ? isWithinRange(
                                          latLng!,
                                          LatLng(
                                              double.parse(
                                                  getp.senderLatitude!),
                                              double.parse(
                                                  getp.senderLongitude!)),
                                          50.0)
                                      ? FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 72, 0, 0),
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(
                                              () => ParcelReceicedRiderPage(
                                                rid: widget.rid,
                                                trackingNumber:
                                                    widget.trackingNumber,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'รับพัสดุแล้ว',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        )
                                      : const Text('โปรดรับพัสดุให้สำเร็จ')
                                  : getp.proStatus == 'กำลังดำเนินการจัดส่ง'
                                      ? isWithinRange(
                                              latLng!,
                                              LatLng(
                                                  double.parse(
                                                      getp.receiverLatitude!),
                                                  double.parse(
                                                      getp.receiverLongitude!)),
                                              50.0)
                                          ? FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 72, 0, 0),
                                                foregroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                  () => FinalRiderPage(
                                                    rid: widget.rid,
                                                    trackingNumber:
                                                        widget.trackingNumber,
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'ดำเนินการต่อ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              'โปรดจัดส่งพัสดุให้สำเร็จ')
                                      : const Text('สถานะไม่ถูกต้อง'),
                            ),
                          )
                        ],
                      ),
                // Positioned สำหรับ FutureBuilder
                Positioned(
                  top: 50.0,
                  right: 16.0,
                  child: FutureBuilder(
                    future: loadData_Rider,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading user data');
                      }
                      return GestureDetector(
                        child: ClipOval(
                          child: Image.network(
                            getrider.img,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> loadDataProduct() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response =
        await http.get(Uri.parse("$url/product/get/${widget.trackingNumber}"));
    if (response.statusCode == 200) {
      getp = getProductFromJson(response.body);
      log(response.body);

      // ตรวจสอบสถานะพัสดุ
      if (getp.proStatus == 'รอไรเดอร์มารับ') {
        // แสดงตำแหน่งของผู้ส่ง
        if (getp.senderLatitude != null && getp.senderLongitude != null) {
          try {
            double latitude = double.parse(getp.senderLatitude!);
            double longitude = double.parse(getp.senderLongitude!);

            // สร้าง marker จากตำแหน่งผู้ส่ง
            final senderMarker = Marker(
              point: LatLng(latitude, longitude),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                size: 30,
                color: Color.fromARGB(255, 72, 0, 0), // สี marker ของผู้ส่ง
              ),
            );

            markers.add(senderMarker);
            mapController.move(LatLng(latitude, longitude), 15.0);
            bool isLoading = false;
          } catch (e) {
            log('Error parsing sender latitude or longitude: $e');
          }
        }
      } else if (getp.proStatus == 'กำลังดำเนินการจัดส่ง') {
        // แสดงตำแหน่งของผู้รับ
        if (getp.receiverLatitude != null && getp.receiverLongitude != null) {
          try {
            double latitude = double.parse(getp.receiverLatitude!);
            double longitude = double.parse(getp.receiverLongitude!);

            // สร้าง marker จากตำแหน่งผู้รับ
            final receiverMarker = Marker(
              point: LatLng(latitude, longitude),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                size: 30,
                color: Colors.green, // สี marker ของผู้รับ
              ),
            );

            markers.add(receiverMarker);
            mapController.move(LatLng(latitude, longitude), 15.0);
            bool isLoading = false;
          } catch (e) {
            log('Error parsing receiver latitude or longitude: $e');
          }
        }
      }

      setState(() {}); // รีเรนเดอร์เพื่อแสดง marker ใหม่
    } else {
      log('Error loading product data: ${response.statusCode}');
    }
  }

  Future<void> loadDataRider() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response = await http.get(Uri.parse("$url/rider/get/${widget.rid}"));
    if (response.statusCode == 200) {
      getrider = getDataRiderFromJson(response.body);
      log(response.body);
      bool isLoading = false;
    } else {
      log('Error loading rider data: ${response.statusCode}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      Position position = await _determinePosition(); // ดึงตำแหน่งปัจจุบัน
      log('${position.latitude} ${position.longitude}');
      latLng = LatLng(position.latitude, position.longitude);
      _updatePositionInFirestore(position); // อัปเดตตำแหน่งใน Firestore
      setState(() {}); // รีเรนเดอร์เมื่อได้ตำแหน่ง
    } catch (e) {
      log('Error: $e'); // จัดการข้อผิดพลาดที่อาจเกิดขึ้น
    }
  }

  void _startListeningPosition() {
    // ติดตามตำแหน่งอย่างต่อเนื่อง
    Geolocator.getPositionStream().listen((Position position) {
      latLng = LatLng(position.latitude, position.longitude);
      _updatePositionInFirestore(position); // อัปเดตตำแหน่งใน Firestore
      setState(() {}); // รีเรนเดอร์เมื่อได้ตำแหน่งใหม่

      // ย้าย Marker ไปยังตำแหน่งใหม่
      mapController.move(latLng!, 15.0); // ย้ายแผนที่ไปยังตำแหน่งใหม่
    });
  }

  Future<void> _updatePositionInFirestore(Position position) async {
    await db.collection("inbox2").doc("Doc1").set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  void _cancelTracking() {
    listener.cancel(); // หยุดการฟังข้อมูลจาก Firestore
    Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
  }

  bool isWithinRange(
      LatLng currentPosition, LatLng productPosition, double rangeInMeters) {
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      productPosition.latitude,
      productPosition.longitude,
    );
    return distance <= rangeInMeters;
  }
}
